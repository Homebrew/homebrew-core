class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 27

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5fdc606fdabc81364a5734f94331830b93721524ee6c14c0f2c742bd6160976c"
    sha256 cellar: :any,                 arm64_ventura:  "4f88e940b44f8d1d31873b6212544989097d33f5e0589d255777f967dad78a87"
    sha256 cellar: :any,                 arm64_monterey: "2a8584f7be455ffd7c88f68687155b884489308af6793d0fbad3b9fad20be379"
    sha256 cellar: :any,                 sonoma:         "5f3643f6a12f95aa6f070697d7395aa47374e4efac968431a5e22499d2524d2f"
    sha256 cellar: :any,                 ventura:        "044a2400f8245ef780cf934add652b83b98abe867a6eb7aafdb3d926beb5fdec"
    sha256 cellar: :any,                 monterey:       "71d2c6793d86bbb68d633c3322191912ae20d9b7d92a2b1cada2d0f9f0bcda60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043c80e0e90448a48259ec37cd6554c1a5ecf541432f6c4530b6f008394a0273"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https://github.com/google/bloaty/pull/347
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| (buildpath/"third_party"/dir).rmtree }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
    inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end

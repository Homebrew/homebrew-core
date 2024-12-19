class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 35

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "983085f6577771a74fb5176697a30d59e122d306fc6dd9121f6ffbfe273cd589"
    sha256 cellar: :any,                 arm64_sonoma:  "0ec0a69df8c1a2bc639c32a571732c35bcc46abddc5628e892b09251e028d34a"
    sha256 cellar: :any,                 arm64_ventura: "9601240af77e5ae52c52671b2e836179cd072a8058356b1ca0a5d471ff13a003"
    sha256 cellar: :any,                 sonoma:        "981b086e66e24e42b0c990a6bd6c8efa1db329675df86ff5ca8de78f59612245"
    sha256 cellar: :any,                 ventura:       "59f2548d6fb00fac9ac0151713656fcf6ad694d1b245038ace9ba3557447827c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba01cc628d226514c5985435b53c420a8336a5690dbb905c1671b85033b956bd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath/"third_party"/dir) }
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

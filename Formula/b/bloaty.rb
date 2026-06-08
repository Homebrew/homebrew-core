class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 49
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      file "Patches/bloaty/system-abseil.patch"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df8ffeb42364db375d407c799e3e8351f209771ff81fc078d277c36bed4b6c16"
    sha256 cellar: :any, arm64_sequoia: "ba3048fb7e8638298cb9685d9e362be8a7b2633b25847bcce0524f89241576a1"
    sha256 cellar: :any, arm64_sonoma:  "1257202d39c14601494f70f8b3c4d647f75fdb298412949d6b06c096addcb80b"
    sha256 cellar: :any, sonoma:        "a5930913cb16c00ca73e7d1dd0b209561180198d84ae1a0bc97e9e419085b1a3"
    sha256               arm64_linux:   "4b1fcbffb4b2c2bdb88e671469b156ed25afd0b672e948711bc09321959c0277"
    sha256               x86_64_linux:  "d89f8a487773f37074043c756f8350883e3befce69049ad92b88873d87b17aed"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    # Workaround until new release with
    # https://github.com/google/bloaty/commit/9677d4938ec5be44f04eae774c94e10d339fd3a7
    ENV.append "CXXFLAGS", "-include stdexcept"
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath/"third_party"/dir) }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    if build.stable?
      inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
      inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end

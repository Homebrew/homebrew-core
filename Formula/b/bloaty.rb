class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 50
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
    sha256 cellar: :any, arm64_tahoe:   "3da17902794a0a9d9c35a9b94f5484f8ce226aeaee52765c9ee99f8f7b688cc6"
    sha256 cellar: :any, arm64_sequoia: "ef227a8332f3b1200222d3ba359c100c8b94d0e52ac219e0a2edd39344ecb89b"
    sha256 cellar: :any, arm64_sonoma:  "32acc63bf8bc25be295e072546ba45dda7fd8f816fc0b951c7585fc92cce5df1"
    sha256 cellar: :any, sonoma:        "34f48572e6af7408a219675ea1bd49cfee3bc807766bd0e399d1f14eac01e843"
    sha256               arm64_linux:   "62f8d27cc364dfc6c2788698226a2318f7a2b08e8f1a8bdaa0a688bfad83da91"
    sha256               x86_64_linux:  "d11b1cd1ae55f23b268cae986810e48b12b95974adda543cca78cba368195f9d"
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

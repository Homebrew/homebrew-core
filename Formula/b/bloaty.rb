class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 47
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/bloaty/system-abseil.patch"
      sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8507646f190fe173225906c0923b9c2e2356ffbf136e83fc1b46195554eeb2f9"
    sha256 cellar: :any, arm64_sequoia: "55576bb3216cf53753a2294afdcf5e5c91a3212cf454d9f47b86595df5068d3d"
    sha256 cellar: :any, arm64_sonoma:  "3c68980aba821d97e636c0ec9678df2686ea82528cf35e0afd5a81239b7a5682"
    sha256 cellar: :any, sonoma:        "314e73716cf224d6a2a10909c26ffada90e233dae48fdcf824d0ecb809ae73ef"
    sha256               arm64_linux:   "eca2391e6a009ead0ec9c5522d332b9d135650d48ba198d102485c461b3b5ec6"
    sha256               x86_64_linux:  "479a5fda2ce669c98311acf9d70b15f91b5c5a761365a525ea76c14d93a95edb"
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

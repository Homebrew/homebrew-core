class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 53
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
    sha256 cellar: :any, arm64_tahoe:   "b141420593707e97537320d4dc7269e0ff3cb432d71b0f07b9e84b787dfb5a2b"
    sha256 cellar: :any, arm64_sequoia: "33278f4bef578c3ac7649297fe9d0c18dcb7a9b5f12f583aa484821fd63cabc8"
    sha256 cellar: :any, arm64_sonoma:  "ebb128ac42a6a92d0fe74f3c7247a8b583be9bf1bec9b6eff05c9f7975082536"
    sha256 cellar: :any, sonoma:        "bc90f437bb5f6ae5f0f7ef45cd8697aeff0479a7665f490c231f091151968f4e"
    sha256               arm64_linux:   "672823a4d612fd22af9fe00d20781e28e57f49adcc9bb0670ca8ffcd0d0e0f7e"
    sha256               x86_64_linux:  "871fc6e606fa0e698b529d24f967fe5b8b9e65c9de866cc2f170337245ff3bdb"
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

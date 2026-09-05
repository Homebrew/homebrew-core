class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 54
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
    sha256 cellar: :any, arm64_tahoe:   "003772acfac3c4bc29f5b733d22fa8f9f7762f14e956400acbe0780ba3555be8"
    sha256 cellar: :any, arm64_sequoia: "b0585a76a909401e65c4439a2e6ab9aa32bc718e73c3895cb418f0ae9b0d5ecd"
    sha256 cellar: :any, arm64_sonoma:  "10b4b4824fb71472d9155d638f4278c657995297923b891f9108cbf5ac95ce81"
    sha256               arm64_linux:   "d1b177476566f0ac288ac4d21148ed3bb436c6eecdcc252ce0c41b6b13c02d62"
    sha256               x86_64_linux:  "53d52026c31260e51857bdeafa872dbf4cd843d8ad22a5dc8d6b6bfffb9b1f00"
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

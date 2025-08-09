class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 38
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
      sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d45489e606171ce0660d451d90a6f388837935fb0a01e774e3f3e231ff5e5111"
    sha256 cellar: :any,                 arm64_sonoma:  "639a9f8cee1d7e2ba1ee4af18b6f23895c57ebd2faaa60eee1478680e3203f9d"
    sha256 cellar: :any,                 arm64_ventura: "ebf0763efb3fc39cbbfa452418ff9571839a91acd864f19450a37ac20828f36e"
    sha256 cellar: :any,                 sonoma:        "76e246f8cb11d76971f8a3dd05196c9ad1753ab4c4dd3f60715f7e4c42eaafbe"
    sha256 cellar: :any,                 ventura:       "d31c3997dd6e3d1f9ef34ab421324d42aa9cbb69a048d329cb3ed734e51a1eb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aee1e659358316c34e23b1ef16d59734f5ea30fbc2c5da04993e9f81014a7c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f274b4494c4ec3b311fe2a57bf108aef2cba5f98aa35aed38ada413d62ab50"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
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

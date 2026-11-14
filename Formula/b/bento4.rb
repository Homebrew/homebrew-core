class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-641.zip"
  version "1.6.0-641"
  sha256 "8258faf0de7253f2aac016018f33d4a04c16d9060735e14ec8711f84aaedf0c8"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23f5b127edf77c6247dbf4e12a18674b293ea73a8d5328d8a1bcd693edf16ba3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd7908ec30ff3ccd37b5b6d884614d59eff3f6b828db0d88968611e86b9b1d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eea70d3d08878646439061a6e419630e41ca3d90b22ac6f235582bc2e03c3567"
    sha256 cellar: :any,                 arm64_linux:       "e1b52385b464ed058e97ead071bbd65a6f03f343d033585821250e2101e46885"
    sha256 cellar: :any,                 x86_64_linux:      "8218133aff9f4f40ebe98369a8ff052fdde498e27fbbd2e8b2fd5353a73f8eba"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

    rm Dir["Source/Python/wrappers/*.bat"]
    libexec.install "Source/Python"
    bin.write_exec_script Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system bin/"mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_path_exists testpath/"out.mp4", "Failed to create out.mp4!"
  end
end

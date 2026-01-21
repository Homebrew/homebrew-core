class Nvtop < Formula
  desc "Interactive GPU process monitor"
  homepage "https://github.com/Syllo/nvtop"
  url "https://github.com/Syllo/nvtop/archive/refs/tags/3.3.1.tar.gz"
  sha256 "8318aff973e0850bea4b9d7d313c513206cdc9b8387e8441681e84ac2bc0e980"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79ceb85e928e2b408064888dc3efe468b806c00b3bfc0611a9d6583c59fc0904"
    sha256 cellar: :any,                 arm64_sequoia: "88557d9cf986f9333a3a63a093475311c8d02506b394d8ca690786b1ed790ba5"
    sha256 cellar: :any,                 arm64_sonoma:  "e07f967450b3c0cfe41ca7f7f4d069450cc9daa5401a17ea6d77854e6ed3c81a"
    sha256 cellar: :any,                 sonoma:        "8524e48ed257d48ee710c16ca6e0ea14e18a6518dce65f7c0727ad2b880847db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f0b836e1e8f581c731dfa0d4599f67a65c4341402c4b58fec3498b53c525ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8498c7cef82206099db804bcaeb06650011db7f5cc8d40d96915b2be36c2d8f"
  end

  depends_on "cmake" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libdrm"
    depends_on "systemd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # nvtop is a TUI application
    assert_match version.to_s, shell_output("#{bin}/nvtop --version")
  end
end

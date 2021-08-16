class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://goreplay.org"
  url "https://github.com/buger/goreplay.git",
      tag:      "v1.3.1",
      revision: "42d89903b65508d8a5f622afa717ff551a4e20bd"
  license "LGPL-3.0-only"
  head "https://github.com/buger/goreplay.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1880cbf5c888b52135b6e74b4504a1ccace8bcc328e183d32b5f0742bb3180d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "193350bae7567c2770169b1e81f4ad359852905533d42e8a1e2bf74158b4d094"
    sha256 cellar: :any_skip_relocation, catalina:      "0f281049b7e7845fa155222d49d817270fce4229364bbebc85d74f6972c382bd"
    sha256 cellar: :any_skip_relocation, mojave:        "c52b65e40a57693f07a84682dbb9d09c0b3d6a5cc4e913da41249525bb8ea8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd0975f2a3bedb8e10ba381d5e415a492fa9a253f67c01cc447499aae696250"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test
  uses_from_macos "libpcap"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version}", *std_go_args
  end

  test do
    test_port = free_port
    fork do
      exec bin/"gor", "file-server", ":#{test_port}"
    end

    sleep 2
    system "nc", "-z", "localhost", test_port
  end
end

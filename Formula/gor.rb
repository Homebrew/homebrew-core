class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://goreplay.org"
  url "https://github.com/buger/goreplay.git",
      tag:      "v1.3.0",
      revision: "c9274ac92a6f021240d82682002240cfceaecd5e"
  license "LGPL-3.0-only"
  head "https://github.com/buger/goreplay.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d36c7ddfc4f1098eaafefdf91717283d2bfdaa333cc4e795ba27ba5101b389db"
    sha256 cellar: :any_skip_relocation, big_sur:       "88b0c408516ecb9d26bc1e6e5c6cbacdb47be8f146bcd52aabb38b63be88b644"
    sha256 cellar: :any_skip_relocation, catalina:      "9cee6cb391872e35c5c8df506734c642612a4b5010bcaf06dee84fcc3af8b283"
    sha256 cellar: :any_skip_relocation, mojave:        "e781aff98642713d24adac0963b7b55cfc1b61e77bee065ef9cc455824789e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24133864aad0cd66b269c13c6126699a98fd17b5a3a7e7842b6ef8fd6c8c7e8"
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

class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://goreplay.org"
  url "https://github.com/buger/goreplay.git",
      tag:      "v1.2.0",
      revision: "2b73ea1f0ceee50bd96f705e23af3885f990daa3"
  license "LGPL-3.0"
  head "https://github.com/buger/goreplay.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b02c8cacea6257c1faf97f6c3a686f09fc1519e54cbd80713b19c95b9c03ced2" => :big_sur
    sha256 "c5cb3c8f00af6a0ef7a8d1c24c4de59563c85bc51bb8a9f878ad4c283aa1954b" => :arm64_big_sur
    sha256 "0a2c7715c47fa3fb9ba70494b1bf20a4216cabb09d909702f86d810a07c58f17" => :catalina
    sha256 "347fab444ceaee3d2dae0f23cedcd924267bbbba95a099ad5602ba3051fd5c1f" => :mojave
    sha256 "0e07f5bf90d57b9bd1b0ccb961e6ee240fd8346a923c45d075b66cd7c4714a63" => :high_sierra
  end

  depends_on "go" => :build

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

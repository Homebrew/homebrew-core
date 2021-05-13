class Ethr < Formula
  desc "Comprehensive Network Measurement Tool for TCP, UDP & ICMP"
  homepage "https://github.com/microsoft/ethr"
  url "https://github.com/microsoft/ethr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c4bf9d6d4e0659f491b6de6d66ddfe3735d8f6fa791debe9e8bfe0aa0e93ddd3"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", -ldflags, "-X main.gVersion=v#{version.to_s}", *std_go_args
  end

  test do
    port = free_port
    fork do
      exec "#{bin}/ethr -s -port #{port}"
    end
    sleep 1
    system "ethr", "-d", "1s", "-c", "127.0.0.1", "-port", port

    assert_match '"Type":"TestResult"', File.read(testpath/"ethrc.log")
  end
end

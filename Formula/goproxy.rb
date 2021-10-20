class Goproxy < Formula
  desc "Global proxy for Go modules"
  homepage "https://github.com/goproxyio/goproxy"
  url "https://github.com/goproxyio/goproxy/archive/v2.0.7.tar.gz"
  sha256 "d87f3928467520f8d6b0ba8adcbf5957dc6eb2dc9936249edd6568ceb01a71ca"
  license "MIT"
  head "https://github.com/goproxyio/goproxy.git", branch: "master"

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    begin
      server = IO.popen("#{bin}/goproxy -proxy=https://goproxy.io -listen=#{bind_address}")
      sleep 1
      ENV["GOPROXY"] = "http://#{bind_address}"
      output = shell_output("go get -v github.com/spf13/cobra 2>&1")
      assert_match "github.com/spf13/cobra", output
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end

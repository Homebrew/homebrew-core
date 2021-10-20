class Goproxy < Formula
  desc "Global proxy for Go modules"
  homepage "https://github.com/goproxyio/goproxy"
  url "https://github.com/goproxyio/goproxy/archive/v2.0.7.tar.gz"
  sha256 "d87f3928467520f8d6b0ba8adcbf5957dc6eb2dc9936249edd6568ceb01a71ca"
  license "MIT"
  head "https://github.com/goproxyio/goproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79bbb0c810d5411ed592e149ce76f13dffc99cc08eeb639fe4939e10b1a588b0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bc3750bfaf43401d883d3b0463518007f2fcdf744327b688e3495562106a0808"
    sha256 cellar: :any_skip_relocation, catalina:      "ff2d41442228fba93e1d08be90f64dd3db210cf47e3543f22b452ed7327866b7"
    sha256 cellar: :any_skip_relocation, mojave:        "5a35f434f319bd48a948c27172bff1d60be27307cfe9cd18bbdfc36ab4e56007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aea5ace7890ba7d5035f69fab75985928a2f8e1a8514e2ab2ec58c3470d9c250"
  end

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

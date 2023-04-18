class Goproxy < Formula
  desc "Global proxy for Go modules"
  homepage "https://github.com/goproxyio/goproxy"
  url "https://github.com/goproxyio/goproxy/archive/v2.0.7.tar.gz"
  sha256 "d87f3928467520f8d6b0ba8adcbf5957dc6eb2dc9936249edd6568ceb01a71ca"
  license "MIT"
  head "https://github.com/goproxyio/goproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e2aa6365f5d64d9ef502521cd45fb6cd8168be310ec0f98264884b89ba46bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "416e6d61492d983b2bc83aecde39fc718a75bf0a13e443d3224d9f9985e7f23b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79bbb0c810d5411ed592e149ce76f13dffc99cc08eeb639fe4939e10b1a588b0"
    sha256 cellar: :any_skip_relocation, ventura:        "aba91922176d4874a6a1b2a6da7fae4fcb669f472d38c259241b0dfb619c1c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "855041ffba9435944868115752c8cc020cf9a30f63e81b236bc00baeb95edc8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3750bfaf43401d883d3b0463518007f2fcdf744327b688e3495562106a0808"
    sha256 cellar: :any_skip_relocation, catalina:       "ff2d41442228fba93e1d08be90f64dd3db210cf47e3543f22b452ed7327866b7"
    sha256 cellar: :any_skip_relocation, mojave:         "5a35f434f319bd48a948c27172bff1d60be27307cfe9cd18bbdfc36ab4e56007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea5ace7890ba7d5035f69fab75985928a2f8e1a8514e2ab2ec58c3470d9c250"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOPATH"] = testpath.to_s
    bind_address = "127.0.0.1:#{free_port}"
    begin
      server = IO.popen("#{bin}/goproxy -proxy=https://goproxy.io -listen=#{bind_address}", err: [:child, :out])
      sleep 1
      ENV["GOPROXY"] = "http://#{bind_address}"
      system "go", "install", "golang.org/x/tools/cmd/guru@latest"
    ensure
      Process.kill("SIGINT", server.pid)
    end
    assert_match "200 /golang.org/x/tools/", server.read
  end
end

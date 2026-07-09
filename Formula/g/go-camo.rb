class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.7.5.tar.gz"
  sha256 "a901a20e1280d46b5615a03bb27ea6872a1c382f0eec909112b805e4ac47bbba"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed94771f4ea8868608c253d4d02acf439ef03d510ba3efbe6ac6ec2569a65137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18aeee00e969d291da7cbf26fe89133934ac03c33a01859bd8b9d5da3ce563ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e8ea00f798546dcd7d59793186f11c4435bc91f796c02bf5124952d31ec80a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7258ca64b1d0a4ecf2dfde560d2689a907ffe3fbee7ac88f7993d9d1c49e5cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77f05a875f155ffb139d822f007e1b0983dbc05365d997a03f6b52b44a833f0d"
    sha256 cellar: :any,                 x86_64_linux:  "021d08fd27c4f75042c0f5674702418ed455fc5dd7bfae82ceb63bf9d4e0e162"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.ServerVersion=#{version}"
    tags = "netgo,production"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/go-camo"
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"url-tool"), "./cmd/url-tool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-camo --version")
    assert_match version.to_s, shell_output("#{bin}/url-tool --version")

    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end

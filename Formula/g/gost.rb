class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "ed575807b0490411670556d4471338f418c326bb1ffe25f52977735012851765"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e454b905ac17f21519f34ed868db709413efb45f53fe37edeb9bd0e9da0259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86b48c89f4ea3d4edaaa3cec855981de9ac0fc36cc82f50b166bf6bf688c8997"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "189a833087438d49b52688387ab96ff43aa9728337fc24c236e007691dae1eb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f65b51d764ccac83750b55a03bb3895cd0c2e32a2e57697fa3323a12499c67"
    sha256 cellar: :any_skip_relocation, ventura:       "4c956460f08c30254b98a089e1ee60a62ca5721f2525638ed16af81c46e28a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de78cc69979d46baeb0727157ea88dc6b6f3c263258e2d99c32040c5a9abd28c"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec bin/"gost", "-L", bind_address
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end

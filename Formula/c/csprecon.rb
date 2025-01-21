class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "afadd6706ef13be458f5bc15bf8549a5772e141e4be49d2fec1507aabf79d4dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b956d3fa9c93b3836eee14686427f38bbecbbf9f32a0bb61086b1a1a8c70cdd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b956d3fa9c93b3836eee14686427f38bbecbbf9f32a0bb61086b1a1a8c70cdd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b956d3fa9c93b3836eee14686427f38bbecbbf9f32a0bb61086b1a1a8c70cdd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ebdc53f7cc7528796d7bcce6078c8b767e86cbf19451cfb7d5e8734a19433c2"
    sha256 cellar: :any_skip_relocation, ventura:       "8ebdc53f7cc7528796d7bcce6078c8b767e86cbf19451cfb7d5e8734a19433c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf65d3c6574d9ae2f00b23cba88ede8f6756c0bbab8932b159c7bdd96b0f65c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end

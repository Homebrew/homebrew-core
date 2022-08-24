class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "d0d1d9a18793f583cab838821d45c43ab41ab59f9105d6cb557bc4789b9b5374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517c33aff026a4d03ef3abf2e3fc3e3778d727a715902cf7ebdfe8f65f34afa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f622a2841ea548ebaf66e4920fabcafa0513d874d072a8fb4fb7c925a9ae35"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f3525ed0829d35f659d02f360a739189262490b116905e073f60a7764b68d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d75e79fe822aaca1ae18db75b443cd8f5aec8737d2e14618d8925ea5fe377680"
    sha256 cellar: :any_skip_relocation, catalina:       "89f2bec9478d9d1fd3a903e5dc5f44528b0ef368d126441f3470f821b5906c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ad150687071e54288605ebce126f545a2ff2ee079391cf86a1931b4ea8f555"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end

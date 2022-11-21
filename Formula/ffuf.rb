class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/v1.5.0.tar.gz"
  sha256 "70dc411c014c826f9c8a7b021e01d5bc50e2cba17e0dcc4df3e2e2574ad12073"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2f6499c70e5b244b8abe805479b0ec2cca21b0e4bf24dc819f6208ae477b300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d5b34bfdf3bd6847630d1a7f3ccd73201776e75777fae174232b1f5749d7db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6845ee52438d068ce9db031323ca9a0773937769a35df93a352a4dc122102ae"
    sha256 cellar: :any_skip_relocation, ventura:        "b44f62708f2ba1aa692812a141e1f58e8825aa33d7678e46bbdd2689341d484e"
    sha256 cellar: :any_skip_relocation, monterey:       "17dc334cfab644570cc9bfe717b08ef80634b44e2ec076944960a2d85f30b90f"
    sha256 cellar: :any_skip_relocation, big_sur:        "64369b07407a6f286f574466a8811a010b5a6dfc670669c378ad48f06c12de32"
    sha256 cellar: :any_skip_relocation, catalina:       "5c55eaee95ae99d1872e39890d34439f64a516234a751780d004b050b8549c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d3ba6aed1ab98173915801272d25cab358b7ba2761608e47addc18dd3feb01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end

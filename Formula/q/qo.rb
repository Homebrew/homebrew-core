class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c9b4187d9b6f4b2a2b4b4be235b4b2e1e7151583bf1165ca91389c54cbcbb16b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd5ed63c536958bc9d2f764d0a77b2abc2a139dd707359688493fffbfd882780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd5ed63c536958bc9d2f764d0a77b2abc2a139dd707359688493fffbfd882780"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd5ed63c536958bc9d2f764d0a77b2abc2a139dd707359688493fffbfd882780"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a29cb34334d3f681c5584276924e25ed7da5cf9c0bd5b4031a6d9d612cffd6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c223cddced2a822de3cf7a0090ec2ab1ff918f8545e87ee250d32ae8bccffb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a21ac403d033f2b445f9b80941196e4b378e1a539132cadb7c67c414a1bc76b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/qo"
  end

  test do
    input = <<~CSV
      id,name,age,city
      1,Alice,30,Tokyo
      2,Bob,25,Osaka
      3,Carol,35,Kyoto
    CSV
    sql = "SELECT name FROM tmp WHERE city = 'Tokyo'"
    assert_match '"name": "Alice"', pipe_output("#{bin}/qo -i csv -q \"#{sql}\"", input)
  end
end

class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "4ee239bd1dd9947b1b32d35c7f5cb79fe26a83c5d50d3b2a91e7496c3da294b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f05829bcbcc717b3a5e15b983185fea5083152e0eac5ce78e3093e65f48cf2cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f05829bcbcc717b3a5e15b983185fea5083152e0eac5ce78e3093e65f48cf2cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f05829bcbcc717b3a5e15b983185fea5083152e0eac5ce78e3093e65f48cf2cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d760bf562ac26e5267be27e4e151afbf4dfe4852ad26e9f8c8a9a7be6597074"
    sha256 cellar: :any,                 x86_64_linux:      "be17fbd9dc26a779cc973e914246bc151bc9282ab36cf75b36fc769d70080e20"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/qo"
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

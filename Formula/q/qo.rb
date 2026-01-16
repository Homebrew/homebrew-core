class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "c1aa18f4e149b43d45270ddb402a92f02aee51cad5d79ec94383d7c5fe078595"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e742bc58d782b0c537996377965361ab089c1bdb731e09ed2529d4e6d7cfdb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e742bc58d782b0c537996377965361ab089c1bdb731e09ed2529d4e6d7cfdb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e742bc58d782b0c537996377965361ab089c1bdb731e09ed2529d4e6d7cfdb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b641b436f181c2ba84a00d61e37fe75d9034becd650267ab01dd8c18cabeb480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40c2b97972fb8374f12a979844bcbff9d9fc56831a7be25bcf3aef10c7a67ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c75f5f4c7bc36c49a48fc9fdce67983a3ec11105cf929940257a51ab50bae43"
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

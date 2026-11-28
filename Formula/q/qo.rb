class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "4a62d20427f961997e03ee04d7241ed951d38b4428f81158ff02a1d42872f482"
  license "MIT"

  bottle do
    manifest_sha256 "ebe211a6f306a5f578792a0763ea6723376b520fb110801809e47b3a2c609119"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b717759ed9502ce00c3aa0b6f24f96beda1e76521cf4b1791263a25087a8e32"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b717759ed9502ce00c3aa0b6f24f96beda1e76521cf4b1791263a25087a8e32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b717759ed9502ce00c3aa0b6f24f96beda1e76521cf4b1791263a25087a8e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "972cb595cfebcc65134cf56eb0684ed5400eea85c2a20b5330c220a1bbbc727e"
    sha256 cellar: :any,                 x86_64_linux:      "5135e96b501c43e9aba7cd196ff6845750adc042061d57787ccb10c390423d15"
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

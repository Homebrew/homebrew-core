class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "54e8634271f15f3dad74a2e4329e81c620fed11d81abd70f95795ceb76ba9304"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bb56727b06d2415b1acb1f5ea42c3b01824b7498cc7f5a3dbe4c0bb1417da5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2bb56727b06d2415b1acb1f5ea42c3b01824b7498cc7f5a3dbe4c0bb1417da5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bb56727b06d2415b1acb1f5ea42c3b01824b7498cc7f5a3dbe4c0bb1417da5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf8c6a7a4fb67f7b581886531db340df5c7d40b57e3f933b1ed204f902f8caed"
    sha256 cellar: :any,                 x86_64_linux:      "457d4ea2cba251515113fe233d42b0392d3e831586d2295696335dcdbb9775cc"
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

class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "917c694772f760e00383fab6ef34c4ce8d186f52c440cad7b3de555b30bc9391"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b90c88a676c693d34eafbc29ac1b468e5d9a3cf27b56c59c1aafb70a950b68f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b90c88a676c693d34eafbc29ac1b468e5d9a3cf27b56c59c1aafb70a950b68f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b90c88a676c693d34eafbc29ac1b468e5d9a3cf27b56c59c1aafb70a950b68f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7714400a647f7ed70b96fec9ad0eb0de64d4e38206da929284858c8d49b6a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63693f55c44b5039f313948be4bc0583d8f8e114adfc481a8dbb108d1d18b623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3890c9179dd06563f1ce8034fec73975cd4d50287db5d4897a7167f8d95ec9"
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

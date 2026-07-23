class Qo < Formula
  desc "Interactive minimalist TUI to query JSON, CSV, and TSV using SQL"
  homepage "https://github.com/kiki-ki/go-qo"
  url "https://github.com/kiki-ki/go-qo/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c0fce1acfc0844c6b0c5a3ef133f861fcddb64d10b72e870c5530cdb3a2fdfb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e708ca99e83055cd381e8264ad6802a6ed92a026e8e8b45846bd88e57143610"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e708ca99e83055cd381e8264ad6802a6ed92a026e8e8b45846bd88e57143610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e708ca99e83055cd381e8264ad6802a6ed92a026e8e8b45846bd88e57143610"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee2696791118bd7a8eae800ce1d1f4190effd15c6cf1e6987b02834d67f7ef57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "481ae3f92cbae5e3568bf10d64c8d9bd236aded20c131051ff8dd4a17806f8b7"
    sha256 cellar: :any,                 x86_64_linux:  "cf9edacc6380c1b0a464e48f5838a4f8e0b7c46ecd99a9fbc205facbdf6d14b8"
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

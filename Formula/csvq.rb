class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.6.tar.gz"
  sha256 "34e112ecd193e8d79433a42ecc237f0f395650a6547047a1b1806376568b5802"

  bottle do
    cellar :any_skip_relocation
    sha256 "47eac248049d1b9fb603b2bc8f6c5354fa3c123f0e65319d0575918ee5ab69ad" => :catalina
    sha256 "432595eaff75550a2a728f1353795a7f77da980420fe63fcca8df2cf22588e89" => :mojave
    sha256 "27af461626136c7bbc5a7e4e6a0cd3718e65d29abd93ef2f10ed725f4ff577b2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "csvq"
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end

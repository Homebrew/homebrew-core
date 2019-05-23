class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.1.tar.gz"
  sha256 "e6423098bc9ef4bd54d482331a3a8a88dc90b15ed2978ba7860fffba46765c68"

  bottle do
    cellar :any_skip_relocation
    sha256 "accfa2b74f9979c47efc859d61b68ea51fdc157b6ab7e90822947d165e4989f3" => :mojave
    sha256 "e31fa0fa47e97c22c26016b1da891de17af1c460a9e0605a394369f8b8644c43" => :high_sierra
    sha256 "ffbe532cd043b30ce29362dc00f6cd29ce2470237e1cb275b8059f7b8a4097dd" => :sierra
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

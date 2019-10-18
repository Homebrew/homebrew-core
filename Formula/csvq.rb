class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.5.tar.gz"
  sha256 "6aa213d65c8bf8503f44711e8ea3c02f7500bcc14d6006dc89dcc602e4855906"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1d7e2c55b13599cc26da71e4048b52ac1dcaa78687c687e24d65541e5453d66" => :catalina
    sha256 "7fa8a6884a00705e8dfd33979ca6291e76d82f7b259381da5057d9df8bffb85b" => :mojave
    sha256 "7d1fc7475e9e1982fce98fe8d6f87db807690c7726f7491b8608e749eaefa895" => :high_sierra
    sha256 "128af1146dddfdc4c0dc78ddb4abf819c784b82e753db132a075087c47c63932" => :sierra
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

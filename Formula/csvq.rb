class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.12.5.tar.gz"
  sha256 "dfe2cc1b0eb74faeb71490b186270b6d963181d37fa38278125d1078e94f5d3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "772132b006351c51fec495f20344af840f8534df356ac56d4171eb82fab808da" => :catalina
    sha256 "595b84cd1c608b8f97b81f8ec333dcc53c62a77b982269056080787a200b0b59" => :mojave
    sha256 "e51a1858bd778e50fccab97f0632bc481ddc9d7d7f0cf4ef00e8a235aeb601db" => :high_sierra
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

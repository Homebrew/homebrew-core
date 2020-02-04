class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.12.4.tar.gz"
  sha256 "4633acb904301099bc421a23a6be2272e9a9d09a4a9045385a6ce4fd808ae6ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fd259d0e172475ca3d6bda6ef84effb6a36250368e24295bda82fef0e344eab" => :catalina
    sha256 "eaebe2858341028eac8cbb675e7412ed96af57a825166a4579c4740379da8611" => :mojave
    sha256 "f9e0c1f3c43a65e98a16319ef9d0876d0c4f06ecea4cb0d107a4bb8b623f1c0b" => :high_sierra
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

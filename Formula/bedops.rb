class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.32.tar.gz"
  sha256 "2039c55d66ac68e5083b7dbcb5b83d232db0877aa60f2bf766d90a14438c8178"

  bottle do
    cellar :any_skip_relocation
    sha256 "29fece51276933f1834724320c2a06ed5b90eaf48bd195464cd762debf8a5a1e" => :high_sierra
    sha256 "238c5b9f8a2e9106d93dd14d7963aba3d5b63a756943db4940cb652ae2f1823e" => :sierra
    sha256 "73f878140e663c81196db24c7c0ce1fbc91b2881991f775ab06597f7117f1360" => :el_capitan
  end

  needs :cxx11

  def install
    system "make"
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    (testpath/"first.bed").write <<~EOS
      chr1\t100\t200
    EOS
    (testpath/"second.bed").write <<~EOS
      chr1\t300\t400
    EOS
    output = shell_output("#{bin}/bedops --complement first.bed second.bed")
    assert_match "chr1\t200\t300", output
  end
end

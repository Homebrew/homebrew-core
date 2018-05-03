class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.35.tar.gz"
  sha256 "da0265cf55ef5094834318f1ea4763d7a3ce52a6900e74f532dd7d3088c191fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fcdbba7e829549668ff85dfd33d281dd09824d6d9b7adc5b7f986c754bf39c0" => :high_sierra
    sha256 "e6cb89dd6bb66f40c09b06e3b9c35184b040a0c2334b59c52e0615cca3cc11db" => :sierra
    sha256 "ac524ad51227b7424026c42a11d2a04db385b3a87e06b6b4036e880002b98cc6" => :el_capitan
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

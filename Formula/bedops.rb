class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.32.tar.gz"
  sha256 "2039c55d66ac68e5083b7dbcb5b83d232db0877aa60f2bf766d90a14438c8178"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4ddaf00c977b2096535519c1f5472f13c14ad9b8c1a534e389361774b653da8" => :high_sierra
    sha256 "4fe107661ee46bb09350b89f2f2d2a08518edb585aae8aaa26d0578c6565899b" => :sierra
    sha256 "55abe5c4a3e6625a7df26f3049aecb589e661b60c32e40c6b4ac3bac26a55c8a" => :el_capitan
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

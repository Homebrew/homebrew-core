class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.37.tar.gz"
  sha256 "740e8598a5d6254b49576868cd8b7cda424f2afe3acaf62d43d186b032e443e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "900e95a62f87acc85744c231c3b1d1d2bec6c3979996a21254ac8cc2f9e45dd6" => :mojave
    sha256 "8d42fe26ff4f6175c1914d9c54f4b90ba608b64c84c1bb586f4dcaaa64b300f9" => :high_sierra
    sha256 "5e39a435a55e7f5533df7dea6ace8d25586260ebad117be88ad10d9bf85fd235" => :sierra
  end

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

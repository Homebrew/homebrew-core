class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.30.tar.gz"
  sha256 "218e0e367aa79747b2f90341d640776eea17befc0fdc35b0cec3c6184098d462"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0ca3de056c5490202aabcf39467c27dc3cba80e8fd561346aec232659d020c0" => :high_sierra
    sha256 "2cda86557abfe9449ef177523789a5bac561a4535579dce12f610b742905ac00" => :sierra
    sha256 "913f411dbc2f1d1cb7a31bcdd804ca97ed24337b158943ad3e53ea7f61961af5" => :el_capitan
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

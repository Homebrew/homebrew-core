class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.35.tar.gz"
  sha256 "da0265cf55ef5094834318f1ea4763d7a3ce52a6900e74f532dd7d3088c191fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "e881bf7969bf3d763f6e1bbe56041779ec32aeb10a193c7922ed84697f99191b" => :mojave
    sha256 "d505812bddf22f9c7b912c5cd7b0f7a5f197bf2fa318ec67c38d899cbc5eaefd" => :high_sierra
    sha256 "3944dbf5ed3a6c2ff825099cdf3d65e0f8aad2de67604ce0523a0468a8832894" => :sierra
    sha256 "a860bbe9e2aa2d5289aa0d960bb01212841f71732eb1e913c8364de46f62708c" => :el_capitan
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

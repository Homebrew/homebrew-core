class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.34.tar.gz"
  sha256 "533a62a403130c048d3378e6a975b73ea88d156d4869556a6b6f58d90c52ed95"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e6bca355ca206b71d5ece7213722d907cd782c907def2c6a6e464c090fb0389" => :high_sierra
    sha256 "0331704de7ea757e4657a486e20f1467d4fdff657c5bec92bef80dd8eb9ddbc1" => :sierra
    sha256 "e11490f1c098290b52b5c7575ca16b5e46180afc94492a7b41b1236cd0129780" => :el_capitan
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

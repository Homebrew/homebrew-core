class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.39.tar.gz"
  sha256 "f8bae10c6e1ccfb873be13446c67fc3a54658515fb5071663883f788fc0e4912"

  bottle do
    cellar :any_skip_relocation
    sha256 "067fa5b0cf0288e60ec7378b07b622218ff385dfc7cadd19ac6fe92ef087aff3" => :catalina
    sha256 "a3e404afc30d1f77ebfd5c713933a36fed137ab2086da3d7a07ff08d2cd36fb6" => :mojave
    sha256 "d30e93e415036d271dd424feebc451de8de2e6ed195f950ff6682623c2969dab" => :high_sierra
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

class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.39.tar.gz"
  sha256 "f8bae10c6e1ccfb873be13446c67fc3a54658515fb5071663883f788fc0e4912"

  bottle do
    cellar :any_skip_relocation
    sha256 "cca7abf4f74c6d0a4ba34cd491a63364a0b1093b5ed7a290d3a8d8f554ce008d" => :catalina
    sha256 "cca7abf4f74c6d0a4ba34cd491a63364a0b1093b5ed7a290d3a8d8f554ce008d" => :mojave
    sha256 "004b816bfd02e79d59e8394dd566561f4638bbf2eb9ada57651bc290f070a163" => :high_sierra
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

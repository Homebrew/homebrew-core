class Grit < Formula
  desc "High-performance genomic interval toolkit (BED file operations)"
  homepage "https://github.com/manish59/grit"
  url "https://github.com/manish59/grit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e428b1fbebccf5974e1daa5af0a53daac0a49e3c33aef33861582c3ba3bdaa9d"
  license "MIT"
  head "https://github.com/manish59/grit.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.bed").write <<~EOS
      chr1\t100\t200
      chr1\t150\t250
    EOS
    output = shell_output("#{bin}/grit merge -i #{testpath}/test.bed")
    assert_match "chr1\t100\t250", output
  end
end

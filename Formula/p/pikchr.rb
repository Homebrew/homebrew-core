class Pikchr < Formula
  desc "PIC-like markup language for diagrams in technical documentation"
  homepage "https://pikchr.org/"
  url "https://pikchr.org/home/zip/ae3317b0ec/pikchr-ae3317b0ec.zip"
  version "2024-02-12"
  sha256 "b07c75d30756f3f19308da2261de85c847b5ea93d001db1341b9829376f7de75"
  license "0BSD"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.mkpath
    bin.install "pikchr"
  end

  test do
    (testpath/"test.pic").write <<~EOS
      box
    EOS
    assert_equal "<svg", shell_output("#{bin}/pikchr --svg-only test.pic")[0, 4]
  end
end

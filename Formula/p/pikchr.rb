class Pikchr < Formula
  desc "PIC-like markup language for diagrams in technical documentation"
  homepage "https://pikchr.org/"
  url "https://github.com/drhsqlite/pikchr/archive/refs/tags/version-1.0.0.zip"
  version "1.0.0"
  sha256 "dd6615e23504301f09511faf1676a342c36e89114397f6fed796f7374bc00c8c"
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

class Pikchr < Formula
  desc "PIC-like markup language for diagrams in technical documentation"
  homepage "https://pikchr.org/"
  url "https://github.com/drhsqlite/pikchr/archive/refs/tags/version-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "55b469fbcc0ebc1b72483760a73a9ba90491fb3b03ac56fefeb71316f8007aae"
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

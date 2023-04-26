class Ctpv < Formula
  desc "Image previews for lf file manager"
  homepage "https://github.com/NikitaIvanovV/ctpv"
  url "https://github.com/NikitaIvanovV/ctpv/archive/refs/tags/v1.1.tar.gz"
  sha256 "29e458fbc822e960f052b47a1550cb149c28768615cc2dddf21facc5c86f7463"
  license "MIT"

  depends_on "openssl"
  depends_on "libmagic"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctpv -v")
  end
end

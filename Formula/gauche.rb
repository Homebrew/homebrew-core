class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.9.tgz"
  sha256 "4ca9325322a7efadb9680d156eb7b53521321c9ca4955c4cbe738bc2e1d7f7fb"

  bottle do
    sha256 "a1937af6853e5f8f057db286caa8aab4565e89e1693ef8d465b8bf287e9de6cf" => :catalina
    sha256 "fec8c41780f5f89c39e772acc479816e95b29e7a2d0720a175339c1402d7d6a1" => :mojave
    sha256 "602e9ee61ab977a245282184c1148d1bbbbd74b8298ece34a55143888299c0db" => :high_sierra
    sha256 "50f5e28b01a2c73be91a0bd64a5069d0965901544186d41150b94ec736b1eadd" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end

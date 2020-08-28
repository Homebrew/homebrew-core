class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/project/gauche/Gauche/Gauche-0.9.9.tgz"
  sha256 "4ca9325322a7efadb9680d156eb7b53521321c9ca4955c4cbe738bc2e1d7f7fb"

  livecheck do
    url :stable
    regex(%r{url=.*?/Gauche[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "0d2bc0fa954237af130845e904c6c1680018c52c0fe60ccdcbb25000ed5b5408" => :catalina
    sha256 "bb0bee61ddd5726151e4569d8ea2c7b5797a82543bb13e45a6fec66a521cdcae" => :mojave
    sha256 "719f5826572a2aec1383ef5501ee4f92580f8a769205c03e47f9e610fa0b5abd" => :high_sierra
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

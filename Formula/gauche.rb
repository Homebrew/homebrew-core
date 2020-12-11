class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_10/Gauche-0.9.10.tgz"
  sha256 "0f39df1daec56680b542211b085179cb22e8220405dae15d9d745c56a63a2532"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/Gauche-([0-9.]+)\.t/i)
  end

  bottle do
    sha256 "3146cc3fa55e0a88f26d1363bbb4bd2144b6dc5ec96766e938e2e5c21ef52b1d" => :big_sur
    sha256 "0d2bc0fa954237af130845e904c6c1680018c52c0fe60ccdcbb25000ed5b5408" => :catalina
    sha256 "bb0bee61ddd5726151e4569d8ea2c7b5797a82543bb13e45a6fec66a521cdcae" => :mojave
    sha256 "719f5826572a2aec1383ef5501ee4f92580f8a769205c03e47f9e610fa0b5abd" => :high_sierra
  end

  depends_on "mbedtls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end

class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.2.0.tar.gz"
  sha256 "685cade90b38138fff75a9e25299d11f574d459ef070c6c939c8232b5b60a8ca"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eae5f12c83215bc9adbfcbff216713a1a0a452d03c2b4adfe9fbaacc4d856305"
    sha256 cellar: :any, big_sur:       "b25c9197f293006018ab337960809c7edfbedc2615aaf4755952534792bc6968"
    sha256 cellar: :any, catalina:      "e15b876676cdc32103cac80b0aa747247f02b7853864b0b7a39a0c6e3454f224"
    sha256 cellar: :any, mojave:        "15663989e35d30bbefd3168d005e1d1de1e694383b2fa54c24f0b120ade02c88"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end

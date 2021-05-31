class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.0.0.tar.gz"
  sha256 "939e88bad00827f3e04c2275b822a416e8fef7369bff6eda7eca1bd1b8db7c16"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bd5bf5424c656cee23a985123c3fa240a927982ba2fa01f326797dc576e01885"
    sha256 cellar: :any, big_sur:       "d385da23b9e8a98eca8b2ce13cedbf2afcb70b26773aeb8ccbfa24e0a4a02a6a"
    sha256 cellar: :any, catalina:      "90d6ae9aba33cea619b8fd15eec19ed8ac0fbb95ff5cf40dea4349846f4c13ef"
    sha256 cellar: :any, mojave:        "37cf0a2c5fe69258a08b07f8d757e756060b829a96720f960aeac52e2751ebf0"
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

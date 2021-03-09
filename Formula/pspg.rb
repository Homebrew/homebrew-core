class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.3.1.tar.gz"
  sha256 "58e166163683f205601997fd6d7aefeff46835b79ca1f62a75aa1fb218ac8cbe"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "239423cabbfbff3fa06a83fcba125150f47d253c433f2c35bc498736b3cd6479"
    sha256 cellar: :any, big_sur:       "442a7f1928e8d44e7db4530311950897d5f123badf3535e8d94aed7d8a0c70d7"
    sha256 cellar: :any, catalina:      "a26969437f017cb7e0012a6c264681afbb15de97bc884b97d7328d08773b2852"
    sha256 cellar: :any, mojave:        "12531c2c1f3194e8b2f7898edc86a071982b9d714c8384d9e71f9156b5425935"
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

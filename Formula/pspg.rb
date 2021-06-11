class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.0.3.tar.gz"
  sha256 "1480950baa121ad8fd5907a551d0b31c8d2c2d3a3a36d4a47a5b62106e7ba088"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3b77e5203dac32db2d0091d827d112807541535cfddd6839b05e3616e47bb87"
    sha256 cellar: :any, big_sur:       "11dbf159afd1afdc874d11e58b31c6168b52eae280cf31321fea66fb19eb0cc9"
    sha256 cellar: :any, catalina:      "e342c4b5eec1096c1889ac27bfa9cdb01a04507779d551c7bdfd94aa0849eb94"
    sha256 cellar: :any, mojave:        "112555beb6b66a2c703c3c75bd73fc4ecae6cab1015c4ad4d833f00cef47e5ce"
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

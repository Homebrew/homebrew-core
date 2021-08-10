class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.3.2.tar.gz"
  sha256 "cf112d3ed9e56734f332835b793389d019b75d9d63da78e62ceb00ca213e686c"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8c247f31481d78b68113c044c3ed8076fd55a53a1aa3cca8118f177f2612dd68"
    sha256 cellar: :any,                 big_sur:       "4349424381446c75ec751820c409badd6dacd1ed8c89018363cf78a785b937c3"
    sha256 cellar: :any,                 catalina:      "06079a8053c5b87b6008af5af1488dc951c290cce7505a172cf59c29e9e3ea36"
    sha256 cellar: :any,                 mojave:        "470bbdc8429129d14a9f6886e94a6494efc035138b2964bb75d817955e10e6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec7c95db6944e84079d961d7a0a3e058b88f879852ee2893766a9b67e31ac65"
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

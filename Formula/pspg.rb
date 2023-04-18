class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.5.tar.gz"
  sha256 "c2614a34d460725ed45cf900cc1634270900e2caf9ee0fac9a85c19b208dbdd6"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3ba8339be31f847ede11e6a10a02d529faffe6b20f1192442add8437fa366b5"
    sha256 cellar: :any,                 arm64_monterey: "4852f3618d9c31ce920da79c464e829ebf752bdf184861ebc1413ebaae4c5921"
    sha256 cellar: :any,                 arm64_big_sur:  "914cc8f4242bab3a1df29590dd3e478f3b4325bb2ca90f1ace2591992d49b221"
    sha256 cellar: :any,                 ventura:        "5955613eb9ce2dac04e488e0762dc80b651c0687f7ca9f2fc738310695ef5b57"
    sha256 cellar: :any,                 monterey:       "44cfd6bcf11b57d50aa3ebe594e064c2924f739f4dc96b58db826d3f51990a4f"
    sha256 cellar: :any,                 big_sur:        "94be2c051ea404ec9ecfb3def047720677f490694c08240008718c6cffa0ca72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77cecdb8d5999f77b5942915114640a3cf868b4182f2b150c68eb69c56afb69c"
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

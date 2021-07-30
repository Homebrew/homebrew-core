class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.3.1.tar.gz"
  sha256 "496e1f568e346ebd62d9a62a32691cd975d36311e3bb15dc347d14e7b2cd6c67"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e9b96f022629f71342837cec5f637dc77fd92cf36685a72f44244e5cd82f81d5"
    sha256 cellar: :any,                 big_sur:       "be03a76fb2a242be65bc4636b4eb49b3fcee5f3e4403fadfb7645b83c208b627"
    sha256 cellar: :any,                 catalina:      "f6a3cfa3c48edf3a96b015290282e3dbfbadb78a0f84ca87f3410971dbce4f57"
    sha256 cellar: :any,                 mojave:        "70db2531357342789963ccf98dd7924b093f25abf846a42274f5b61ce2d31bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bd57dd500688382bdc228a8aa264c310b8c1422a87dabf3ea33377c1f538a95"
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

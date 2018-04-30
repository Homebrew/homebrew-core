class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.1.1.tar.gz"
  sha256 "91fefbf18a07223e66db4f09ea01b4b14829945ce318c0bf39b6efad4afbd2db"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "1725ff9cff00ec80839d349dd6c75ea7f765cdbaecd73e3854676a7ce6dfc7b5" => :high_sierra
    sha256 "8460f72aa012329de26c9af6a699aec5b2fbb4014355cef288cc21eecfba0d53" => :sierra
    sha256 "085695b61ef0c3fee0fb6f56971ab8b4018415ff1cfdeace264f64c706ea1ad0" => :el_capitan
  end

  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end

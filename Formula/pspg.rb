class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.1.5.tar.gz"
  sha256 "9b78637908129937907f71de00a487c7dc94a4988019232771c7c1654a5edff8"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "519ccf7058225a96d5962d1e240181816f9e7d100035097bda4ba1c8423c124d" => :catalina
    sha256 "3ee78f74d59629d9e3d19bae221c070ca78b89fa6ac4bf1e17b184cc5bd9da1e" => :mojave
    sha256 "64362c755fa53b687756b563af76ec4b3d4ba2283a5cab9f21b2f8409d2dc2cb" => :high_sierra
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

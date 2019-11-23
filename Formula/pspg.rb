class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.5.5.tar.gz"
  sha256 "fdef17e5ebe4211962cc7be01a9c4ae9672af4ae54865e6227c26ad269d1bc2a"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "176811eeb5c2d8b3d41c96b907bfe0bd41c348c3ba0eb2ac0b08cf2593d1a3f5" => :catalina
    sha256 "65a050cce1994343bd357c63d948738eed7c7989a9e64c13676c4d8f589dbb8d" => :mojave
    sha256 "fe5cbf052d47393042837cec2db676769df49630b20e33e67003bb72e274ad47" => :high_sierra
  end

  depends_on "libpq"
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

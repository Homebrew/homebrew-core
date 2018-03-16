class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.0.0.tar.gz"
  sha256 "1035015f8fb29c749d5c1d023db0c391c79c2fa7180cfecdf788dd7e9c9a0fbc"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "90a6ebca2055ec86e0a7dd3531a4fcfb7532828c4ded8c5196ae371a9a6b7872" => :high_sierra
    sha256 "6658ac290ab5810b0ac30af7d574b28ab3684663c5a81f4c518897316873e587" => :sierra
    sha256 "60d1b34fde061af4c0fedc04cde1ecc9a50860dd4493de32bd1c2213fb8dac67" => :el_capitan
  end

  depends_on "ncurses"

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

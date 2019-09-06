class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.9.0.tar.gz"
  sha256 "fad790b404170e828673a86f9a657b2191df63102ce37b248e57a8cc7f169285"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "4a83a7740eaa0f2ed066f433c602e15b59987d7d97accf3606a2ac622c04cc19" => :mojave
    sha256 "f17fcd5fe499357203143ea2648f0f297d2216c193d4caf6ead6851ace54811e" => :high_sierra
    sha256 "5ef975b422421e2c840242531d4395a2b6ed531a742b68b01da8b37d9849cc39" => :sierra
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

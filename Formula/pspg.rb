class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.0.0.tar.gz"
  sha256 "1035015f8fb29c749d5c1d023db0c391c79c2fa7180cfecdf788dd7e9c9a0fbc"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "e61513e3232835b661761a4143e71d74ab3b1ad59ff5b5e44d8fc8512049930e" => :high_sierra
    sha256 "000505b737172b0a55cd9b429c6080fa43987c9a7e2991f03cd0276432b99905" => :sierra
    sha256 "4d84ee7f6369b4c215487d1d7e3281040be599bd261100c6fd99bbe94a36f374" => :el_capitan
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

class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.6.3.tar.gz"
  sha256 "5ea8499a745a14428323419f256c4c609437e6c6c0cbd839b47137c398f5640f"
  revision 1
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "78e87ef94d45c242e35278aa9a08c58e323a5b416787ef82face8152eac6d8c1" => :mojave
    sha256 "e54f3a97bb410cb15a1dddf862a9c516568d339533317dfe3a4e3894951f41e5" => :high_sierra
    sha256 "d38a0cd6834d50e9e9e3a3edc55866c7c3c110f4e091d93923f9290f246ff076" => :sierra
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

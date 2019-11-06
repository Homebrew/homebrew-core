class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.5.2.tar.gz"
  sha256 "62b1761bcb6387bd5fc8106b634949d3658a833dcfb0cc78f740e72f379b257d"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "abaae75486c0fb419bfa62a13542365418473bdfab3f8301d9547d0ed0b0588d" => :catalina
    sha256 "aa0aa2c46ed0751b2000d0172baf4f9ae4bf94311a9a5720ff2a199d0e508854" => :mojave
    sha256 "8f28f25db36e5a149e893fdc2d6425ebfe00447a83c04cfb3511740e1b0bff77" => :high_sierra
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

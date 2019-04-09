class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.6.4.tar.gz"
  sha256 "076e043d0a19edfbb560146f73fb49393e314532306d85c588d1b00981b42aa8"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "f9f565cadb2557e3cf353c5636fb65fe688bd74c4d4bd24ccee0949cb8c574fe" => :mojave
    sha256 "f8618651c9724546269679e659ddfa8bc78d826d05d561bb5a1f922a3260edc6" => :high_sierra
    sha256 "a77d65a1bd17ffab3da9c157090e9033532c6499ba139a9a098e04bccf6b34f1" => :sierra
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

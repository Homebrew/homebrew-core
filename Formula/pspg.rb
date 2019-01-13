class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.6.3.tar.gz"
  sha256 "5ea8499a745a14428323419f256c4c609437e6c6c0cbd839b47137c398f5640f"
  revision 1
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "a28915e206a6db5116efa20d16563379af59b7bdf58880bd35c9c26152df8b03" => :mojave
    sha256 "6ee5b150248b945bcc602bab058dd4c4e692086572c8d06fa51d0ec806f36b47" => :high_sierra
    sha256 "1c37fbefdae58ed4387b4246f1674add326a7e0c1e74a6761663756c61b1397c" => :sierra
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

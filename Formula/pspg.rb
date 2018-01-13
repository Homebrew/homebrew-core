class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/0.9.2.tar.gz"
  sha256 "c1953f5ea08acc26e6509bee46aee0e19132f7ccde27bc8fd5d5b1a70fbabf87"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "21455e883171c09125c8a5552955f02389e6135b778b77f008e32172fd3a6cae" => :high_sierra
    sha256 "e796efc23ce3535c3229df95fb7eecf392f05c4c891fbe47dfdca23a802da56c" => :sierra
    sha256 "4de179de3ea34aac5e74b59869b51d0b037e32a643987ab080177711fbeebca2" => :el_capitan
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

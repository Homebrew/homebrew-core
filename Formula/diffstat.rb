class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "http://invisible-island.net/diffstat/"
  url "https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  sha256 "25359e0c27183f997b36c9202583b5dc2df390c20e22a92606af4bf7856a55ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "30255ba9338a70f51fb80f44cc3993b98e44bd7946f5b598252f9a7d1c6800e9" => :sierra
    sha256 "4b383a964ff74029f6555162d7548e11c1fe8a9f2295671484419c8e32016ede" => :el_capitan
    sha256 "fb1b7c5b2802e7f13afcf58bd694eec31577c76ec9e32bbdef8254d08ca9866f" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<-EOS.undent
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 '25359e0c27183f997b36c9202583b5dc2df390c20e22a92606af4bf7856a55ee'
    EOS
    output = `#{bin}/diffstat diff.diff`
    diff = <<-EOS
 diffstat.rb |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
    EOS
    assert_equal diff, output
  end
end

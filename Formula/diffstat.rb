class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "http://invisible-island.net/diffstat/"
  url "https://mirrors.kernel.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz"
  sha256 "25359e0c27183f997b36c9202583b5dc2df390c20e22a92606af4bf7856a55ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "458fbe3438d70f1cf4904e63b1563d6a4a3c0bfd83448e8ed8e142459854e36f" => :el_capitan
    sha256 "8f191c34cebece4e6576daa5eab661cd1eec78957e508c3b369a9eed7019c475" => :yosemite
    sha256 "06cae3bee231b56b08c850fc0b3721933296de4013bf5f8894e8395778bfa3f4" => :mavericks
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
      -  url 'http://invisible-island.net/datafiles/release/diffstat.tar.gz'
      -  version '1.58'
      -  sha1 '7a67ecb996ea65480bd0b9db33d8ed458e5f2a24'
      +  url 'ftp://invisible-island.net/diffstat/diffstat-1.58.tgz'
      +  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
    EOS
    output = `#{bin}/diffstat diff.diff`
    diff = <<-EOS
 diffstat.rb |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
    EOS
    assert_equal diff, output
  end
end

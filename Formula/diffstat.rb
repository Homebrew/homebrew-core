class Diffstat < Formula
  desc "Produce graph of changes introduced by a diff file"
  homepage "https://invisible-island.net/diffstat/"
  url "https://invisible-mirror.net/archives/diffstat/diffstat-1.62.tgz"
  mirror "https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.62.orig.tar.gz"
  sha256 "7f09183644ed77a156b15346bbad4e89c93543e140add9dab18747e30522591f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6501d14bb3ff32347b902fcd6af24714fd88928e9ec2b4685821ccc2828160bc" => :catalina
    sha256 "f2ddd2775174056c48eab541d32b99cfd2cc586e0227c4f2eec4b15bf5ce7128" => :mojave
    sha256 "ac1e5199d1776d52adc03842b378da475f1db1282150ed9ce22c365a5b0cf7dd" => :high_sierra
    sha256 "c6f9fd47c9736faf0cfb2f3e0ab6490e3974b4dca06d36f4bf01967c56aa1c14" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"diff.diff").write <<~EOS
      diff --git a/diffstat.rb b/diffstat.rb
      index 596be42..5ff14c7 100644
      --- a/diffstat.rb
      +++ b/diffstat.rb
      @@ -2,9 +2,8 @@
      -  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.58.orig.tar.gz'
      -  version '1.58'
      -  sha256 'fad5135199c3b9aea132c5d45874248f4ce0ff35f61abb8d03c3b90258713793'
      +  url 'https://deb.debian.org/debian/pool/main/d/diffstat/diffstat_1.61.orig.tar.gz'
      +  sha256 '7f09183644ed77a156b15346bbad4e89c93543e140add9dab18747e30522591f'
    EOS
    output = shell_output("#{bin}/diffstat diff.diff")
    assert_match "2 insertions(+), 3 deletions(-)", output
  end
end

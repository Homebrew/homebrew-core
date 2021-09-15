class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.11.tar.gz"
  sha256 "3e8a0e0c45bad3009341dce17d71536c4c655d9313039021ce7554a26cd50ed9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d996baa1c8f5384514e0a8ba4945cf07012664cfb481f2c9f7309d30053d5844"
    sha256 cellar: :any_skip_relocation, big_sur:       "46d768ebba1aa240540fd620fe856d259b8e316567204b7002052dd6a6241696"
    sha256 cellar: :any_skip_relocation, catalina:      "50c51fd0770177e688cf98f358b2383e2ebe250b0bd8bf25def80a1b8da1c318"
    sha256 cellar: :any_skip_relocation, mojave:        "2eae57977bdfcade27141c865d01aac1ace6be66828e9e0294f12a473fd7a35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7993153f7f73005baf13fa6ab5b1dfe011fdd92c188d4cd69aad9bee98e432de"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end

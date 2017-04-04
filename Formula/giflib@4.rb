class GiflibAT4 < Formula
  desc "GIF library using patented LZW algorithm"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2"
  sha256 "0ac8d56726f77c8bc9648c93bbb4d6185d32b15ba7bdb702415990f96f3cb766"

  keg_only :versioned_formula

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-x11",
                          "--without-x"
    system "make", "install"
  end

  test do
    assert_match /Size: 1x1/, shell_output("#{bin}/gifinfo #{test_fixtures("test.gif")}")
  end
end

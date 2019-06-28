class Nibtools < Formula
  desc "Commodore 1541/1571 disk image nibbler"
  homepage "https://c64preservation.com/dp.php?pg=nibtools"
  url "https://c64preservation.com/svn/nibtools/trunk", :using => :svn, :revision => "649"
  version "2014"
  sha256 "4e4bb0d2872084ae45d208ccf0868e1901fab99eb17e972e2f0351de63ac840a"

  depends_on "cc65" => :build
  depends_on "opencbm" => :build
  depends_on "opencbm"

  def install
    system "make", "-f", "GNU/Makefile", "linux"
    mkdir bin.to_s
    cp %w[nibread nibwrite nibconv nibscan nibrepair nibsrqtest], bin.to_s
  end

  test do
    assert_path_exist("#{bin}/nibread")
    assert_path_exist("#{bin}/nibwrite")
    assert_path_exist("#{bin}/nibconv")
    assert_path_exist("#{bin}/nibscan")
    assert_path_exist("#{bin}/nibrepair")
    assert_path_exist("#{bin}/nibsrqtest")
  end
end

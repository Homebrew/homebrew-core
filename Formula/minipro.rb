class Minipro < Formula
  desc "Control MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.4/minipro-0.4.tar.gz"
  sha256 "029ecba6c2eecb86d9e137ac71bd93244bb53272230581520f29209edb825178"
  head "https://gitlab.com/DavidGriffith/minipro.git"

  depends_on "libusb"

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "MANDIR", share
    end

    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/minipro", "-V"
  end
end

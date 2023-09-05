class ColorCode < Formula
  desc "Free advanced MasterMind clone"
  homepage "http://colorcode.laebisch.com/"
  url "http://colorcode.laebisch.com/download/ColorCode-0.8.5.tar.gz"
  sha256 "7c128db12af6ab11439eb710091b4a448100553a4d11d3a7c8dafdfbc57c1a85"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "http://colorcode.laebisch.com/download"
    regex(/href=.*?ColorCode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6edce11909c604ec73a674545bbc5f52aef25a5d8bddf4ef2a1b185482204958"
    sha256 cellar: :any,                 arm64_monterey: "cb5165201a0c376af40363735728829192ceddf00a37a23d9496f9a1079ff4d2"
    sha256 cellar: :any,                 arm64_big_sur:  "230e39299a0ac01dd732121694f21b4810be03d1606395c55117277e94a727e1"
    sha256 cellar: :any,                 ventura:        "453cf1ef4b99c3a1236d531aafe7d17e2fc958791e0f9abdb7f45c0a47281ebd"
    sha256 cellar: :any,                 monterey:       "6303d0e13b8ca60ba2da4885d755d8e90b0b140add503018f57c549c45079626"
    sha256 cellar: :any,                 big_sur:        "b343754e096af4d184b860a0e30a5dc2ed3d8f973bbecd8e0a64ec2c0371dc53"
    sha256 cellar: :any,                 catalina:       "3ec0f990d19f9d9162896a1f0806f314dad5925346ef48eda9ce500b3a73435e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49bf9128a81486c66e92b0382a448a970b20c32a01d296aaeeca8d1a9c4995c2"
  end

  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake"
    system "make"

    if OS.mac?
      prefix.install "ColorCode.app"
      bin.write_exec_script "#{prefix}/ColorCode.app/Contents/MacOS/colorcode"
    else
      bin.install "colorcode"
    end
  end

  test do
    system "#{bin}/colorcode", "-h"
  end
end

class ColorCode < Formula
  desc "Free advanced MasterMind clone"
  homepage "http://colorcode.laebisch.com/"
  url "http://colorcode.laebisch.com/download/ColorCode-0.8.5.tar.gz"
  sha256 "7c128db12af6ab11439eb710091b4a448100553a4d11d3a7c8dafdfbc57c1a85"

  bottle do
    cellar :any
    sha256 "92a73a595c94c657676c5b0380c3a6aef9de725e88dde65656e9848e0fe81605" => :el_capitan
    sha256 "c10fcb700a0c47abef3727c17dd689215e164102a16ac3aad9444f29b7fb9139" => :yosemite
    sha256 "e06d67b2033015f2112fdee7dcd20de8057aa112be7cd156f87c0e0b36e19ba7" => :mavericks
  end

  depends_on "qt5"

  def install
    system "qmake"
    system "make"
    prefix.install "ColorCode.app"
    bin.write_exec_script "#{prefix}/ColorCode.app/Contents/MacOS/colorcode"
  end

  test do
    system "#{bin}/colorcode", "-h"
  end
end

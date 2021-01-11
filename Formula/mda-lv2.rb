class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2/"
  url "https://download.drobilla.net/mda-lv2-1.2.6.tar.bz2"
  sha256 "cd66117024ae049cf3aca83f9e904a70277224e23a969f72a9c5d010a49857db"
  license "GPL-3.0"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "c98df66e1d834f99c433066c4b64114c61b8a6f0b69d2efec156e27d229c3864" => :big_sur
    sha256 "d82ee3c76fc7247c99ced5d4ea1450ac73e0488afc8f07344eba9ba32c9d2f04" => :arm64_big_sur
    sha256 "d79b7ac328f0064f2ca3d14b4ddfb7dc999aaf5386f21e7122d239dca72dfbbc" => :catalina
    sha256 "852451a5e46cacc35f5ca529d2a9edba3d6874c21e1d0478c46cafcb93c8291a" => :mojave
    sha256 "616562cb40d0af01063e188d5d46a505455a947fc93c008b0f0eb6c65d0dd2af" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install", "--destdir=#{prefix}"
  end
end

class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2/"
  url "https://download.drobilla.net/mda-lv2-1.2.6.tar.bz2"
  sha256 "cd66117024ae049cf3aca83f9e904a70277224e23a969f72a9c5d010a49857db"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "11305c6dd1065f380811fc8fa2058d2885360eabc95592a926e583fe43c0d6a7" => :big_sur
    sha256 "70a7e6c2ec6687191da96a243d428d3a36f39f2eafbbea149fd2518dc70001af" => :arm64_big_sur
    sha256 "479125c63a6736dbe110711d9978764f1b44bb2520aa9646c2ca2fb7aa914f4a" => :catalina
    sha256 "d10c751b2b276f037f4ee8b4cbe00871fc390c47661957ba96713161b1f6411a" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install", "--destdir=#{prefix}"
  end
end

class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2/"
  url "https://download.drobilla.net/mda-lv2-1.2.4.tar.bz2"
  sha256 "a81a00e19594881174526cd6ee7a3e301236e0ca25191982f5c9af5eb8d96ca8"
  license "GPL-3.0"

  bottle do
    cellar :any
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

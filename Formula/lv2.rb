class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.14.0.tar.bz2"
  sha256 "b8052683894c04efd748c81b95dd065d274d4e856c8b9e58b7c3da3db4e71d32"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d933ca909a217d2b1820a883d8e0245bcb78597f68c77890d6b37debe910c27" => :mojave
    sha256 "76cdfc151001c6faeb0ca4a8cc9aab877943a96af3a92c0ddf514fafb1e47996" => :high_sierra
    sha256 "9612d259fdbfa42956e58e8b71188b7fe259258453a34a623f3c99af69d87418" => :sierra
    sha256 "2986387faf275715556b26ca612b8099031a98933d8f760b17e2c0ea4b770fc6" => :el_capitan
    sha256 "2986387faf275715556b26ca612b8099031a98933d8f760b17e2c0ea4b770fc6" => :yosemite
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}"
    system "./waf", "build"
    system "./waf", "install"
  end
end

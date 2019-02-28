class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20190220.tgz"
  version "5.0.20190220"
  sha256 "378f9111c10933fc36bb29f52f565184daed1daf412ac17c630d1e851a830b28"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c3bf3e1869e3b2575c0cf2dec92224b80670315aa456dd095052efef2ed6ab2" => :mojave
    sha256 "0c3fcdf9ba94de9ac1ad148956e3e9d927964891223a2a2b32317ab8f9875104" => :high_sierra
    sha256 "c5bc4254da7f5378913c36ef878728fc865fe30fe0063317278f302247005f7b" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end

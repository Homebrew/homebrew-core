class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.17.tar.bz2"
  sha256 "5985beb39c960a3cb5b0e70d6a121687043dc8458e5783777ff250303cccc42f"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4eb6f695e2770188371433e28574888c0e869a94eed6384eb346dea9447ac24d" => :big_sur
    sha256 "d5b4b56e737b3dd6bea07aeca8cb06cce2bd5b2c92923e4e065f8cc8e85a0cc5" => :arm64_big_sur
    sha256 "393daa46a9bc661060ca7132feb7d635cc08ad828bd3512e4d27d29a315a26b3" => :catalina
    sha256 "8a1021a90a26783b1b2127dadac4dcd7d50f0c3e9e8d412a6ee2b0b61160088d" => :mojave
    sha256 "a6b73540c7ed94ba539e24ade74aaf0281b1895184766085dc0af5b7923a1180" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end

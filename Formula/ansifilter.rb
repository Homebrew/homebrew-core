class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.18.tar.bz2"
  sha256 "66cf017d36a43d5f6ae20609ce3b58647494ee6c0e41fc682c598bffce7d7d39"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?ansifilter[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5b4b56e737b3dd6bea07aeca8cb06cce2bd5b2c92923e4e065f8cc8e85a0cc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4eb6f695e2770188371433e28574888c0e869a94eed6384eb346dea9447ac24d"
    sha256 cellar: :any_skip_relocation, catalina:      "393daa46a9bc661060ca7132feb7d635cc08ad828bd3512e4d27d29a315a26b3"
    sha256 cellar: :any_skip_relocation, mojave:        "8a1021a90a26783b1b2127dadac4dcd7d50f0c3e9e8d412a6ee2b0b61160088d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a6b73540c7ed94ba539e24ade74aaf0281b1895184766085dc0af5b7923a1180"
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

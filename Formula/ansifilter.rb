class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.16.tar.bz2"
  sha256 "7fcd2fa3520bce2bd3834c299f533cbfb43a29a095c83e8fea372a383dfbbaf2"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "29cf09137837f8830ba67d6e8aed9fc2e21192edbdc68531e8c33e5f75b14209" => :catalina
    sha256 "8498a78c79a4e22b9d644a957508f9641443e10ed00177cb75d8aa9377f7e940" => :mojave
    sha256 "0e28ecd7fccb6753e0f2b056f553f1434661cbda4972a82b253e3f696762247e" => :high_sierra
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

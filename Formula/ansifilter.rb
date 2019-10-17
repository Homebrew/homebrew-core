class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.14.tar.bz2"
  sha256 "e2eee3912718b226d3217e2848e5c5a447bf30b7fbb9f0ebc8dd4ddfeb4797af"

  bottle do
    cellar :any_skip_relocation
    sha256 "61f514bb17e9af97717cbce217fe72c3499e7643ee75d0727c98112e9fd42410" => :catalina
    sha256 "78a752145456f9be0bf7eb0639c0797ee61f262d3305c95ebd3efafd43568176" => :mojave
    sha256 "0038d6bc9d690591df08c050a63fac325174df8c6cb64264524199f4b0c000c5" => :high_sierra
    sha256 "3b242df11f164808dcc618830b5ecd0ac85f1ecc14943a6695eec0bd849327ce" => :sierra
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

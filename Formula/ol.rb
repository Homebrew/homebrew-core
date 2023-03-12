class Ol < Formula
  desc "Purely functional dialect of Lisp"
  homepage "https://yuriy-chumak.github.io/ol/"
  url "https://github.com/yuriy-chumak/ol/archive/refs/tags/2.4.tar.gz"
  sha256 "019978ddcf0befc8b8de9f50899c9dd0f47a3e18cf9556bc72a75ae2d1d965d4"
  license any_of: ["LGPL-3.0-or-later", "MIT"]
  head "https://github.com/yuriy-chumak/ol.git", branch: "master"

  uses_from_macos "vim" => :build # for xxd

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"gcd.ol").write <<~EOS
      (print (gcd 1071 1029))
    EOS
    assert_equal "21", shell_output("#{bin}/ol gcd.ol").strip
  end
end

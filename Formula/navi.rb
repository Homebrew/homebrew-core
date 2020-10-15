class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.12.1.tar.gz"
  sha256 "167c1781062d2621f2d07059e71f5b1e1aa0560798d7799971681808a6d42ed0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "171dd5b3887c1728a16cdb1169c49c2ed1440647ad4541aa9afae6ac60dbfad1" => :catalina
    sha256 "a55e7861b4604c1ba8acac766cd1b89a83a6d0ee644def396f89baae26a5aff0" => :mojave
    sha256 "14297fa981aa825970ca6ea22369faea3056ca2c381a45195195698fa060d71c" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end

class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.13.0.tar.gz"
  sha256 "995c3a9ecb11964cbccbdfb63bbda037e4ee4e7e6e4c08da8e93c41b2ec1d830"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcfc006389ea6eeac0a8688f34021a1fffba6519a1b4dbed0b87bfae47579a6a" => :big_sur
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

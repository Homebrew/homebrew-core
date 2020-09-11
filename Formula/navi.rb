class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.11.0.tar.gz"
  sha256 "26024af3034ae16b914b467a56b03bfeb3ff3d235d72faedd2d48186e6ac024d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "51333482e0ba4482f1cf13371ff0af5c5f7307c1e69f4efa429de9615a902c24" => :catalina
    sha256 "f88552c05b92201d0a324fbbf3e6fb7a3bebe5fc18c3b9973e0a8bc92fb06d80" => :mojave
    sha256 "1b19fe95435f45e6ffcfe2e5261f236c9865911858dd9e713167429fff31f875" => :high_sierra
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

class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.4.1.tar.gz"
  sha256 "3268317a09372f435a08c8eb5f62c44f2a070f195482b5e4584a9761a7edadd4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffaeef29096b9c280ad987641fe0840cae82c62ab3d2c6273d90befb379f8e80" => :catalina
    sha256 "00daa9ee59ceec7c528e4dea56f1e7f5b4b82d9896e22631627e6f91ce4a38f4" => :mojave
    sha256 "50e131b634ea5ce8b8fb4e216fdcfc51d7721ae9ff0be2527b67453aadc3af75" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end

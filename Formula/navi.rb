class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.7.0.tar.gz"
  sha256 "47a6aa786702eb5387e9bc77790749d77240835293982cffc9ba3a329a359c13"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bb0a094d284ae344216ff510acab238c0ac9de53d62718736692ddcfa82b4d3" => :catalina
    sha256 "d01ac98c9b810e673232f9e56aaa8e3316866d0e3579d7a3ab349fc68cc68f6f" => :mojave
    sha256 "05e2b50a3d499792f11f3faa95afb74e4c4d3b1556a6ab53b65f43cbb62ff1f2" => :high_sierra
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

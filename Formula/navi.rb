class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.7.0.tar.gz"
  sha256 "47a6aa786702eb5387e9bc77790749d77240835293982cffc9ba3a329a359c13"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd7432f723f657709bf9dc0fe378de6fc498c012f7e6db32823c3b6e45e41e23" => :catalina
    sha256 "7b12857ae9904c9c7202960655739c374eb8cf07b30aaa7e24f1fe16a8abc18e" => :mojave
    sha256 "ba4f09d3fc9bb35478c6774a1d5f9ed1ded994c22fbce66842c8c38c5cae6f22" => :high_sierra
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

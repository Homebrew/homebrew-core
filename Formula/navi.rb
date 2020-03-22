class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.1.3.tar.gz"
  sha256 "bda5d5650279652b4d0708385ccd25bf1b37c8687f7d2cce875b012c5a12b700"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2a27d935902fa10647638c8d82c6c6ac1803657f98bc06a103f725aa10f1d1d" => :catalina
    sha256 "52ed26b8029d4f17b9a3f31dd4c152fbecc7f40d6891ba6475ca3a2601dbef4c" => :mojave
    sha256 "e9e2fabe9e8283d4780513a9e396c3c598679b670d04b146bca8f7b84f393e32" => :high_sierra
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

class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.6.1.tar.gz"
  sha256 "2d25a5bf62c65418861fc6857e60815d271fcf4f1b5a73170c8761a258c695cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "db5af2299f5397b63faae54ae25846d3211b6fea775f4937ab73ef0a8e5bb460" => :catalina
    sha256 "175664f8c50c4119d722e55133d6ad8d55cefa80a206fd5379d9aadb8cf271cf" => :mojave
    sha256 "3ea66c527c215bea5d6913141f70680e70a66a96ddfb3f68bad3432056308d45" => :high_sierra
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

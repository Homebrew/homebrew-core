class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.12.0.tar.gz"
  sha256 "2331a82f91dee35bd3a1c3cfc14b23a69f9d2ff65a8b7b840ead4e76e8e1f146"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cc29aa50c9cb3de55b234d5e22369f63f5170e6438ac333a69f36f04e292aca" => :catalina
    sha256 "877fce4517bb0a4372f69b77be7ae350b6356677af100d678bb88f11833335c4" => :mojave
    sha256 "873a26616cc5a1da1c7f7ac7a89d5d4539d919f5fa2b0e2212e52b7d20a0ad08" => :high_sierra
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

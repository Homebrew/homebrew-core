class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.9.0.tar.gz"
  sha256 "cf81f7000d66b47899119e8110df6380308e9d625f0fbd62b2ab9ecd0ef7211d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4ceecbdfd55639a759d240db593b24af918c460fdcdf062e1bcacdb68c29dd6" => :catalina
    sha256 "5ea206ef9c7d10c00a0a60ed26ab941aec0fb516bf9d3146a95ef836e095b0f5" => :mojave
    sha256 "062d323e514c0c1688f6fcbf8d4708409e713db60b217343a8aeb8424998c6cb" => :high_sierra
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

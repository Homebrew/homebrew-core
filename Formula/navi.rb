class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.16.0.tar.gz"
  sha256 "f4767e4ad833c16be556d690b2cac0c9bf0a3ddfc4b782a832f6f1f1c3add9c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "128391e2960a52d6dd7ae61910f2848193e147b632455ca29cd63f8879d68def"
    sha256 cellar: :any_skip_relocation, big_sur:       "a10e743963436737be4caab65832ebbc34494cd9a4a6cf7714bea2a56e4097a7"
    sha256 cellar: :any_skip_relocation, catalina:      "9bbc1a4bdae98ace4c09fc5a5510539c72da9829b73def0a52f7fe53bb6d74eb"
    sha256 cellar: :any_skip_relocation, mojave:        "450e9827aa1dd65ad20a1a2b5f0918b3de8c4ed4935f521f2856a00206e9346d"
  end

  depends_on "rust" => :build
  depends_on "fzf"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar",
        shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats --query foo --best-match")
  end
end

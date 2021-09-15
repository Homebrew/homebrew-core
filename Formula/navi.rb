class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.17.0.tar.gz"
  sha256 "3402d4847720be4a930e29946bef592e6f4e270e8e0d4e3d8809f57a1d03e2d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15804e294d289233b43a7144cdf75339df598fbebd92ee9de5c4b84bc90699c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e297366638bbea0f735a5efb491ffcb9be8ab13b005a34f40d5573895e4fd665"
    sha256 cellar: :any_skip_relocation, catalina:      "50f06154a09b3927a240d6346b6ca72552347b12a75a4634eb633c16b7da0f50"
    sha256 cellar: :any_skip_relocation, mojave:        "ad9b1c1da07794686886dac478791619e2427ce1ca0917908ca12b7169be9954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5e80fbcebf2f418458aa3db89a0c55ef80fd6ee3df16ddea3c9adda7453b38"
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

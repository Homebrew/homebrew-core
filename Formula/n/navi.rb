class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "579a72814e7ba07dae697a58dc13b0f7d853532ec07229aff07a11e5828f3799"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8093e5cfc77a522ca2d056cf05b88469d0fa1e0a2b1b23c18979563452390dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70aa50027162f722f693ba32d9bb353afcf7c40c3545e76ef250eeb557f4cc99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "140549f076afcf2f2efe544b058a96aa1abb8976fd103d78d7ab61043329b7a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a65f5ce5dfe35522fc6d05997b920a285a432371aa6fe1833139bc93dc8e929"
    sha256 cellar: :any_skip_relocation, ventura:        "b90304e22015f382d40c456af751a7553ef0e31239a8188265db9af23e8f3c98"
    sha256 cellar: :any_skip_relocation, monterey:       "83fcc31b379c29f5e290d67be3753d5f17a58dc0a41c99c0c6e9357a12ee1cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "607ff2e3619f53a47921cc23d6f1249daf9b92e8ab8caca142ae688faa7d37e1"
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

class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "4c10f47c306826255b07483b7e94eed8ffc1401555c52434a56246295d3f2728"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "164b6bc6da84bf4ba668b338c22242716f844ebb4ed90dbac98b73d7b5433926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a732472b8c33807c91a31262c5846ab54573065e4dd5607ebfa091e38e373a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd14604b76454e6c530c032b0af690d969d956086a2c47fac647fce1f328937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3ed6e03a9e3872469df60473a0ffd9fe8948a291c8dc8257d1cb67ee442dad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a23f84baf95a5a955901f125840d05c11ecba50e7453ac0e18015471da15a2f"
    sha256 cellar: :any_skip_relocation, ventura:       "34775384b07e23691e7e8159dd684a39b627bd2ebb77433757e6df6ac6deec99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa4b10ede4b81b48185af35208e2dd75a196c04cac9fab7dd4eb398b5d3581c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d36e08b9840f8a3080c62f126bb0da33f62972441ca609af73d1ae25d4bacf"
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

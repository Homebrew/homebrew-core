class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.20.1.tar.gz"
  sha256 "92644677dc46e13aa71b049c5946dede06a22064b3b1834f52944d50e3fdb950"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71399ba7c59e04855badb1309fa81eb6c48757e31b04c59c3b5a42cf78973924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3bb2b249c57ae944ad9c515d70f072929c126bc5c9d1df5d43bd3106c8d5d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a60a72700856dd95f8cb98c73c8737e0235941e195e736794fbc04141dd82ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "a539e18267dfd460ff777152ed15b8b934b70a9773bf67b7a998a5479e815771"
    sha256 cellar: :any_skip_relocation, catalina:       "82675a78df97c77d907f43cdd46485e5e6980972b43f774827a97fae37cbcd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10cc4bee98130ddcbc749036d4eefd44a89bb5aeed33eba7bd14b576cea3485d"
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

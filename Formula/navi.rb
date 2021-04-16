class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.15.1.tar.gz"
  sha256 "73d91f1c47df50cf4bb2fb5856f58b580a65a59090c847199bbf37ca421f8b3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a82ce10aaff0f73a01214e6cad918ab00fe3c6ab00dd38293afb5f7ffd84198"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa91236237c099dd06fd6ac5a90de499b8c16b4fefd41a7a3cdedf95a7bd6074"
    sha256 cellar: :any_skip_relocation, catalina:      "bc5d1c68995626d62ec26ffcf80c40faa4c67de4cf97f03fc6829bb163f67a05"
    sha256 cellar: :any_skip_relocation, mojave:        "31cacfc7f9a5a440c717f199021774d5e5ef698d00b03dd1d129b3948d33b996"
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

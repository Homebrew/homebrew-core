class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.20.1.tar.gz"
  sha256 "92644677dc46e13aa71b049c5946dede06a22064b3b1834f52944d50e3fdb950"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e1f305a736151e7b8f0ce663473ae0ad157ee323ecde375d8e785f3715031ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45bf6450777e0d4511705d307b0fb43f2e5d903b72b068f8fb607ea704d5a5d8"
    sha256 cellar: :any_skip_relocation, monterey:       "fc51318b00bfc22da74663a62bfaed9df05763f699089f44db76e4dbeee1d6f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "386fb5bb8ebd3ef54aaaa9e0553ad626db475f5bcef83057dddab300d505021f"
    sha256 cellar: :any_skip_relocation, catalina:       "cb7747c8b690e7038969c7ed3897fdcb5fe85c52e6af69ff791746e3c90f66d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734ae47b3664ff96d387cffac0247a19217c85544c401d269d10699da47e2ffc"
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

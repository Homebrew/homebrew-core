class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.20.1.tar.gz"
  sha256 "92644677dc46e13aa71b049c5946dede06a22064b3b1834f52944d50e3fdb950"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "763fd30ffdba5cf9ed61b50c2f1d7e04773442b30ebe6dd8fa70ef2c7e8d3883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a809f73efd4e6cbdfddc844dfb284363e3031e2e20c8e442f50b6845abf8761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22dc945109faa0692af5c79c1db7173cef89c67eaab1700ed6c7c5e125f16bf2"
    sha256 cellar: :any_skip_relocation, ventura:        "84c66c44f1b8ac726c36e8f86d8457523b131ae14feb12f56ac342efdd935eee"
    sha256 cellar: :any_skip_relocation, monterey:       "7d8a47501f686c61c1ceffb057c8ed4c3366ee1e7944aa67edffa174c1730286"
    sha256 cellar: :any_skip_relocation, big_sur:        "9acea618a7b032bf5d123661b9ab7f6c7268a632adb627b52db66169b378db9b"
    sha256 cellar: :any_skip_relocation, catalina:       "25ecd84c6671431950dbc914f5b6dac4cbb1a08d48e9fc906aa267a4ec39d771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edf0da79bdc799528664dec37ea7e7eb5378304c34c775a1678c081a90b9ea02"
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

class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.15.1.tar.gz"
  sha256 "73d91f1c47df50cf4bb2fb5856f58b580a65a59090c847199bbf37ca421f8b3e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6384ccd33923d21d6ec7f39cd74ffeb9c8924dd899a982a30d2b653a8aba37d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "7264fe7ec239e213fa8261748dcd09b60b261ef0bce4accc8392f43dff7b17c2"
    sha256 cellar: :any_skip_relocation, catalina:      "baad69e04bbd0accda3e715705d335d2dbf21cb16f0f2a3445c5a0277fea25d8"
    sha256 cellar: :any_skip_relocation, mojave:        "8f74ba262fd8065ff68cfac84b213a3618a35f379e321d7920c079c02b6aecc3"
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

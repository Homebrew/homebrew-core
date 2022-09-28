class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.69.1.tar.gz"
  sha256 "963d8e26fd919a2246f9ef01f9e8d5110f0f947525c39842c440edcb17938631"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2caefe08fbb3af842e373d932b2e275d92b6aad4997850d29f33913e38a3d01f"
    sha256 cellar: :any,                 arm64_big_sur:  "61db6a46b5e65bccc5fc7453cab01ada4107b252ba14022080d66be534e23b88"
    sha256 cellar: :any,                 monterey:       "4c7272a389601890048e829901e2634172a3a06198b35fd1f194375022888e24"
    sha256 cellar: :any,                 big_sur:        "9b3c1175b5c0eb4680cf26f4748aa02992ce70d554e99e5a9f59bd6188b8cb20"
    sha256 cellar: :any,                 catalina:       "4697fb26a3fe5e0456f844d4ccf42ad29c5f57b1d3dbb2b6f2f8f62e0c00682b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62315758b2c5313efded710dcc084bdb1baf1af4cf76daca0d51ee43cc556c1"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end

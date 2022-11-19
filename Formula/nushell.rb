class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.71.0.tar.gz"
  sha256 "0f3a279ead004c86c44b6c9991e9e838b819dad23d65add7250a9691ad29f209"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "180696a18c5a1a3f6e3f0cda7c15ba4aa2d8169af2bdfbd15f63efe476779c20"
    sha256 cellar: :any,                 arm64_monterey: "3bc293b155061f6e40ab59f6e26d2e7e7145b50ec1d814cfcf5d62e8f05d42fc"
    sha256 cellar: :any,                 arm64_big_sur:  "43f90485a45be3b172fe9a23adef31d67283afa3b7e3461f0f21f1cbd466f061"
    sha256 cellar: :any,                 ventura:        "0c4cc1638b1b70ced9876309f0481ed4a83418b7c475be434e0ee132c7c6f1f5"
    sha256 cellar: :any,                 monterey:       "6a4e709177a1ff1425ba375b34a2de4b82e33e0f7278678f64c2ef33664deda7"
    sha256 cellar: :any,                 big_sur:        "357bc0a395b239103eafa43cec8b3e8b286406ec5dba995d4c8a3166384379b3"
    sha256 cellar: :any,                 catalina:       "a865313149189e176e662369d234685466447c2caec2a0bf890a23637e946643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29a46a7069274ab77dcfce20b158f3167e7ae355bfb5234db5df59831ba46dcf"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

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

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.77.1.tar.gz"
  sha256 "37b767351e1a15ca59988f2257d61a52f035a35079e8a304ff59448a46190df0"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8cc8ee4e5f3c8d2ffca503b1b294d631e4971de6052f0a4331c7fc592996a302"
    sha256 cellar: :any,                 arm64_monterey: "63296f536f75bc9d776601f003418eb0ea729869298127510cd6b1607e1a260f"
    sha256 cellar: :any,                 arm64_big_sur:  "f93ebfe0481ce012548139bf8af9c696c6c35bcb61309cc13792f3dd79568d95"
    sha256 cellar: :any,                 ventura:        "a158d84c1d2033094c93d8f6d3f5ddc7fdfd5d9e6618e8e587c57a7307bbb077"
    sha256 cellar: :any,                 monterey:       "1c532746ee9936a653c7e1e8fbdf26d15462addefeb010439bc32304446e2597"
    sha256 cellar: :any,                 big_sur:        "00daa33dc6489d0334781c5ead7dde5e9e861c07c16daca996376aa38ec07114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "964f49f0ab4d96422edcbec432398688c78e56e162f0715b793d9298b4f4b703"
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
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end

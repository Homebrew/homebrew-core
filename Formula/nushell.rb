class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.79.0.tar.gz"
  sha256 "cbabc26ce509c672db943f3ac6d44d1e3efbafc3b5929411ac209afe14848ef7"
  license "MIT"
  revision 1
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50cf7a00c864da78104c244cb81b9588f8b1249cb2575db0f7319211430fa8ac"
    sha256 cellar: :any,                 arm64_monterey: "48222d6bd0fcc62dc9d0bf707737d064a194de291e6e06560b27f2950424fa51"
    sha256 cellar: :any,                 arm64_big_sur:  "3e029f99711609ab065ef5ec214b9df1223ed67fdc66b5f9220db36595c60856"
    sha256 cellar: :any,                 ventura:        "18523d29cd9d6957fe37fe46731756d30bf1e1ac7ca95799450700a189ec7de3"
    sha256 cellar: :any,                 monterey:       "50e22b31f55d491ebccefad8877841660f654ae51cfa1e0e4dd600ada737d28d"
    sha256 cellar: :any,                 big_sur:        "ef5e2e7b9be92bd0bb5c84636451ce0c786f3cfb152b325211879724b20c2550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c33909fae91b4058a644f06aa2935abef2802eef11a2093fc60f5f31b22c6a"
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
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

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

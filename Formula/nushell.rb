class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.70.0.tar.gz"
  sha256 "315d6f9723c9b036bb0ba268c236f84ba7fc3e3fc36be8e1c45f02dea1b077c4"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7fb75a4673dbf8d9bcad78b9cc2a0540d0ca200e9644344b440dbb04e980f324"
    sha256 cellar: :any,                 arm64_big_sur:  "9cc249eb72903cb4133e30c24146646b44ec544b9f6005e2d723a0a023ccc74a"
    sha256 cellar: :any,                 monterey:       "53c57d8f4abe24167d98fb780a3d4bd528a12dc821c05e1f4c1e2adadc2150e2"
    sha256 cellar: :any,                 big_sur:        "9ecbd1fea6956446d537aca1caa747b4514c3b25e12ed2b9807f9f159313adc8"
    sha256 cellar: :any,                 catalina:       "09a4b490ab5c2ace892d202eda9e1a0b05725dae489c816c5cc9e9fc6709a773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce8877db212ff0a03417ff79c8bd9df90353f184429431c18c25e123cea30b1"
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

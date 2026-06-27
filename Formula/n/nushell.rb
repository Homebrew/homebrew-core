class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.113.1.tar.gz"
  sha256 "d2b514b9ec7c1cc5930025528987d730cadcaa0f063227691c837516093328fd"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1e015cb3a8d0f96c3e4a64028695e7f8c3fd4882f11d95a9e5071d05f26be67"
    sha256 cellar: :any, arm64_sequoia: "cdccee78d13657ab79d5661037724a3dc7fe226497796c13887aeebd9a8d1ec6"
    sha256 cellar: :any, arm64_sonoma:  "c0285c0b7656f9612bbea92859a35086d813f9bc3ce1e74eb6df650aa0e20a18"
    sha256 cellar: :any, sonoma:        "efb9c0e1bbff2f08c1008a7b3021695d14cc31eca59d7e9b5d0ef2f8ad03cd36"
    sha256 cellar: :any, arm64_linux:   "040e33f033c3e1cc4e69abb7fae97a048ad8b7238ad4088c663e170cfa64ebba"
    sha256 cellar: :any, x86_64_linux:  "3aae40449933fda154a901f6446f87e5caa2e5e2356c65e9ddf4fc6e695eb1ab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["NU_VENDOR_AUTOLOAD_DIR"] = HOMEBREW_PREFIX/"share/nushell/vendor/autoload"

    system "cargo", "install", *std_cargo_args

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

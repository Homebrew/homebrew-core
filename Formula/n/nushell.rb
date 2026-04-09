class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.111.0.tar.gz"
  sha256 "e3a7980bb5532016036d9fdbbe0a2acc5a73f9549d1842ff6c8c0de2a6d1ddbe"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d292370338f3c820c2ac8040d01856afcf803be19f0a391c7f01a8f2bb77ee1"
    sha256 cellar: :any,                 arm64_sequoia: "32351158fad811644a3ac60428ca466ebe3886cf231136b31c88ef901f7b7d35"
    sha256 cellar: :any,                 arm64_sonoma:  "5346199fe456f9129797ddf10d80495b6759d7ad16e13bf552c28eadc98a722e"
    sha256 cellar: :any,                 sonoma:        "bc9781a2e9fe83a337b0b27a103025a7e73413c3924a1b6d5128477ff6fbb97c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "201d9c8dc8fafb3a72d5ae5517858e27461dd26695928d019a666d0594aa47d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b26ee65afef9c522035f69c6d6b5044c39a1be16700e1ebbaedec47d1ca8f2a"
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

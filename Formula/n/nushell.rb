class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.103.0.tar.gz"
  sha256 "0e654e47627ad8c053350bbc25fa75c55b76e11fd6841118214eaa5a10f9686e"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c31377bd391d2f0f2dcffcd5a1c7051cc093f739a73a522625f46b5d23ebf018"
    sha256 cellar: :any,                 arm64_sonoma:  "fb7337509d53b922f70c6eb61a8eec005b700e25211b49b09205fc9fe38a5ae0"
    sha256 cellar: :any,                 arm64_ventura: "910bd17638b019196e990cbc3f306449b2cb4ebeec66152fe0cc3d3335d54af4"
    sha256 cellar: :any,                 sonoma:        "3ebc77e9dcd4018ff3ada213018cd82a3e20bf16e3b7e1b9a1610abfcd36ea56"
    sha256 cellar: :any,                 ventura:       "c640dab7ebabc7c10255e8bac9120fa5f10acfb701af643ab32255aa592b584f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "561dd4d2839bf8a7c11d05dce2fbc43c1ff90a1d082bfbe06799266e82aa7c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1db8dbab5fa1685593f11484f6f59fe4d35068a5fe702a3b2dfb84185ef5bbe"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
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

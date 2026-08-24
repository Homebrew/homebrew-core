class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.115.1.tar.gz"
  sha256 "06df93281a0f858019d09ea6cf821b19a7cd9017cdfb9e898cfe8dd4bd8101c2"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f678dfd862086ff6128b88dc81408627182bea32af9760922c901f33801507f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ee47a2bf7b7cf524b3d1efb16f98218aee0e7202db44971a799b0580c8af1dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fba8d351459ae7d1087fbac9e60d76ce8dee32ca1c1dea55c500e80df5c83416"
    sha256 cellar: :any_skip_relocation, sonoma:        "619eeee5c683cb390c7f7341544c1689de6b99d5fea3fb352e7fdadea996842b"
    sha256 cellar: :any,                 arm64_linux:   "b51ec5cf71f930dd3ac9cb0a75039a240cc79310ba65e77948c4005523fd9cd1"
    sha256 cellar: :any,                 x86_64_linux:  "5d781a13a8866c7ee34fb9277da469154b0dfd2977ada6024e7431a5417827fa"
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

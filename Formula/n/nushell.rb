class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.114.1.tar.gz"
  sha256 "48ef2fb6bb3ec2b1dcff87a792aeebdfab10b29f3119a62291075b17e4ad25d5"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78b13979ae8435f632514bbd0b80965165c60e169245693f129b03b3ebe0fd2b"
    sha256 cellar: :any, arm64_sequoia: "43935b4b33f36d158927ab7ba9b968ea852e3f08b8171b0e20d525d402e67cf6"
    sha256 cellar: :any, arm64_sonoma:  "12ccbf1995c845a4b97d3348361330057b05df1621ef21a59ceeb898ef8b1eff"
    sha256 cellar: :any, sonoma:        "0414d5c1985845afef89a32674b3dc37b5c16dbe38ef3be8f5bed80deb0a3d94"
    sha256 cellar: :any, arm64_linux:   "29f83c9cc14aff2bc57e73c7fd9af9cda90c561bf16ced0fca88c1c8140146f1"
    sha256 cellar: :any, x86_64_linux:  "cccb83967934a5bb271f2f0041e157e40224fdcb37ed2e661434c8c69e31b661"
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

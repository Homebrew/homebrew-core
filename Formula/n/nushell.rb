class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.109.0.tar.gz"
  sha256 "b6087622414448edc3cf2ab44a339ad7a1de24de92ed7dc425da504f767f25bb"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79d1fcd8e265598bcb2128d4095b809188ac5c26cc19c33712f29800d34aa071"
    sha256 cellar: :any,                 arm64_sequoia: "faba4bdb4285eb844585d7fdb09dd44eccdcbc5b163a29ba557637f56f589837"
    sha256 cellar: :any,                 arm64_sonoma:  "9ebd5b1f49ee8e6432166367ad10de88cea5c06dff5e0703b7035acee0c37c5b"
    sha256 cellar: :any,                 sonoma:        "2a243e2a1175dff25bf2c9f7264a1fa4fe2a1a5c473789d7b3539eb15368f630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc085fc06ab4e622c248d8ae800118ef628286a7ead9862bad69c0621572ebba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f18c489b4be5d798e68d009d61c676f96acc5fae5d7a2ef19eebd40a7fc68749"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
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

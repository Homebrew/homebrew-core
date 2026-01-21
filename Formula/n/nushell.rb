class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.110.0.tar.gz"
  sha256 "e4c95f743cea3d985ab90e03fd35707a46eef926d407ed363f994155c1ca5055"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e44aec9807bc10480a2404c09d1f479a01cd00d4750fc26496af950b346ba4a0"
    sha256 cellar: :any,                 arm64_sequoia: "13313614d6dde1605c991eb65e4ad60546f40255f88cd4d50df1d53a71b469ce"
    sha256 cellar: :any,                 arm64_sonoma:  "fe1a2ebbe34562ecb8cdccf41dbdbcd9ea250acde4d77d282a9bf2b8d09113cc"
    sha256 cellar: :any,                 sonoma:        "8bdfb326d3c91560021db861376706802d99884c2c331f8d787323ccb269555d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021a3a20d734860eb0f3961db87cf5bd83b2b3871e6c408cb425c004804699f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4778d3500ceaa798d53822df2542d93defb2cc4f7e31860e7fd1fcff8ccf8a20"
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

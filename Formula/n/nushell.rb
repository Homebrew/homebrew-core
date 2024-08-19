class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.96.1.tar.gz"
  sha256 "829e2f91d130d7b0063a08b1fadb737bdff616ac744eba43baa5fc42aa8b682b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d637b8ce5ca2b9cd374af98be4d79750f00d99ee698b4f285b71acf925db54a"
    sha256 cellar: :any,                 arm64_ventura:  "dfe05ee5be6ae8ef8c23901bf1f312d6a2b951d18e83dc73f234a3d7f351de30"
    sha256 cellar: :any,                 arm64_monterey: "1a9eae4f38b9288e734fa490296f8420eaa74b4e2da1e1853c7c05a3afd878ef"
    sha256 cellar: :any,                 sonoma:         "4bf1b86d30f898ae045e0c9246ad1c8a543fa1f0c7daea9e27e4806601106065"
    sha256 cellar: :any,                 ventura:        "8f43840f3abc1ce8bf9bc035f0590a2b659d74a9f6d45d28bf9ca9fa478682a6"
    sha256 cellar: :any,                 monterey:       "296a1153d66f69ed2303609e3fb6b814b486afd3b8472dbd8ac9461b38547c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efb15646948abb34b7a740aa89ac6e9b39d03ef3d9774ec87b9778cf390c4f0"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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

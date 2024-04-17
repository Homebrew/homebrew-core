class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.92.2.tar.gz"
  sha256 "d0424380981164137b9db31f686b048b7a4b9fce1a2e06ae6b8e58df0b8c4d64"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9075a85bfa468ece23b6c46c4ba5650505b2ff25b98b7fd3ae1bbac69f8c1efe"
    sha256 cellar: :any,                 arm64_ventura:  "0330342ebe202e56b55e1808b968a7c808f2b293a10af85085bd9413e59a7849"
    sha256 cellar: :any,                 arm64_monterey: "f6963d36f4d05aeac13626f7d23a6588203dc17a8ee66fe81b319d42422859a6"
    sha256 cellar: :any,                 sonoma:         "fcf7f7c06ba30b1cd105119052605a2a04fcb4aef249f09db0e826ce3ac4c9f3"
    sha256 cellar: :any,                 ventura:        "2f7a51eb82c10eaf25ce7e9db7f75916332e7accdc51da60a62c6a720b553bb6"
    sha256 cellar: :any,                 monterey:       "ce728f4fcbe8cbf819ffdad0073c4ced1bf977c783565221902fb62051c43f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a5f4b07ce62ba4bef8d4fa0d92ec8a26c33d5233c92e2e6009e2769ecc992c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
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

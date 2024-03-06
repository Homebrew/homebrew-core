class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.91.0.tar.gz"
  sha256 "8957808c3d87b17c6e874b8382e8be45100e83c540556b2c43864c428c2b80b5"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3c7edc3e08ccde9dac8dbac06079a1a2d4ddf774e56708c979d5e9d5a253d3f"
    sha256 cellar: :any,                 arm64_ventura:  "63350c367bbce231d39b9df253c71cecd4cca0f22209dd78e85784ee8623b920"
    sha256 cellar: :any,                 arm64_monterey: "22a39ea70c93fd2442d41261d2ee8dc79b8ea9138cd2e64bd1d7dd8953b87f9b"
    sha256 cellar: :any,                 sonoma:         "560e805d923e30075e8b59b081c7c1ae7a8f723529776a982cebef8676b5576b"
    sha256 cellar: :any,                 ventura:        "09c2c2e36fc60d130269b7147dcd230fa4e1b33b6309237dcd9668e844eccd22"
    sha256 cellar: :any,                 monterey:       "6ced3e558f08d30433533a85bc604ba5de4508e1061b5017b8aa26d28fdefd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37ffd28a499c80840d172a9c76af76bb480fa129008a75e5dd87d990fb56eba"
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
    system "cargo", "install", "--features", "dataframe,extra", *std_cargo_args

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

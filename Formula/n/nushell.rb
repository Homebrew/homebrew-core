class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.94.2.tar.gz"
  sha256 "19b8ccb30f63da7eadbc8d9afa69318d9cbbb40bc162558604a24b8773ccd04a"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67e1bd1dfda551df79d07c9cfe90b3f710e2ff4f6f632e754d1bbf49bba0abba"
    sha256 cellar: :any,                 arm64_ventura:  "19e7b05868efbf78662bc35bbf7b35fbb454d257f0865d92afeced30562c86a7"
    sha256 cellar: :any,                 arm64_monterey: "191d8abe65fe8787e51d979865debacf2f35bb35e2e03a46b4ba054d093f9f93"
    sha256 cellar: :any,                 sonoma:         "34e6d025537b9b5e17eb49a45a90562e4daf0eb9a04ddd02e59ef1fef0b7c06e"
    sha256 cellar: :any,                 ventura:        "3aa618dd611d20d629a2a337e7348c9b01a8c493ee70efe1234d21cae2945fa3"
    sha256 cellar: :any,                 monterey:       "bf88809a3a97b9bbfb8eebed5b7c5450024684ba0bf5e5a2b9019164ec64edae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a727d163abab2dbeff77df9b0c00ca06426b1bc1840f1a77c96d71bf37cd8f4d"
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

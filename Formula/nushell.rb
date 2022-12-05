class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.72.1.tar.gz"
  sha256 "9f921243512702bd02845a58f8d9225e432667084f4d5e3a8d6375bec2f92f31"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd78d6e139fe23cba7faa930f4686e950715dd5582c9f48ab56bd75b71303f76"
    sha256 cellar: :any,                 arm64_monterey: "572c98fc3f4d667e2ba572ba74eb1a40c6bf9c04096b2cb07ffdd3e01d24a9ab"
    sha256 cellar: :any,                 arm64_big_sur:  "8e6e0725836e20e1b1500b0ae73cc01053aa4e6a2641a03a13e394481e54f7ae"
    sha256 cellar: :any,                 ventura:        "1206cef8ff677e0e1a0fc36784e4e9757e2d085fe6d99be64b6e346110e818a9"
    sha256 cellar: :any,                 monterey:       "a8e7c792c7c9ffd7249d99c13177990e4c488f474c4f6fb4fd42bbd8297fd692"
    sha256 cellar: :any,                 big_sur:        "6383964c19c20cae140bf8013db78ed1590982febc73aba7bf08af3625c885b8"
    sha256 cellar: :any,                 catalina:       "8a3cba8990049007a1a9a2f13e648776b73ad3305f0df72d0532c41a9892595b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96eb75c7ae1830fea6e7df7d20e1ebe2e7d1d71fcddbd609ef5cc1fe5193d7b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end

class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.109.1.tar.gz"
  sha256 "53d4611113a17ed3a29b0c81ea981d546a40dafca77fdcd9af7a7629ceabf48f"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba75d900565cd99a5600edef5927ca8a228ef7ccbc4dd285099e3dde58277785"
    sha256 cellar: :any,                 arm64_sequoia: "38cfb08850bc925c402c3057cd61db74d115ae527dcd0e4bd463a0adc5c9f1d3"
    sha256 cellar: :any,                 arm64_sonoma:  "7299f4de3fd13a28990c0e774773025ea304150ab51b458671b0d82c8104d42a"
    sha256 cellar: :any,                 sonoma:        "be53b0603b72998bb8c2dc48a81756543b65b7633f8eda3475bdfebab76c13cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a3213e5ac9346a8f069794bce731d518417574f1ccdb623ff859304b32e659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c52c0734cc74885f95d1e01e891e364a08c5585c138babcabbcef699c36af7ab"
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

class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "61f3e429ad642ebff91dfa6d910ba097535f82277ce1d66715a28afc19842884"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e07c2ea1597ff7ad5b1f5dd7bcf7aa9fcd1387a2ac6b1da592f8b10fecf258a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fc9b9006022bf6966e5742988dc5f00e247e6fdf4c32272235c7fc339084237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e70691e1e13ec0a3322423f64ec080fcc2a73d70c096e1f8c48afccc9b9a4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e645581a5ab3fd9c9f77f2002648ffeaa7d92237e665538793df8ab16285132b"
    sha256 cellar: :any,                 arm64_linux:   "d4fca7121fec4c02c1cb2ea2523fa6a08de85988baacc16ef86ae205dfec8140"
    sha256 cellar: :any,                 x86_64_linux:  "1ace6ece717c984e44874ec7862db0d7cf646c04a6eabe7a51d94c3eb6dfb36b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath
    (testpath/"concord").mkpath

    (testpath/"concord/config.toml").write <<~TOML
      [display]
      show_avatars = false

      [voice]
      self_mute = true
    TOML

    (testpath/"concord/keymap.toml").write <<~TOML
      [keymap]
      leader = "space"
      StartComposer = "i"
    TOML

    assert_match "concord config OK", shell_output("#{bin}/concord --check-config")
  end
end

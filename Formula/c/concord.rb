class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "473059af85ca8c7d2433ebd2a024951a8159c6109399fecaad238deaf2fd717a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9e4978b8d41176a7fc20c189a6208f644fd0605efd111119d57965f7b7098184"
    sha256 cellar: :any, arm64_tahoe:       "71d4374817e8dd73ac361c553bd2cbbcac338356d3fc9e09905e88ddf6a53f48"
    sha256 cellar: :any, arm64_sequoia:     "a3a2162de4ac77a7bc6e108a60b46108176ad8c6d0fbbe3c41022a472dedb275"
    sha256 cellar: :any, arm64_linux:       "5a36e9eafd1798959dad64e00b1f79c8f350eefbdfa1590d88f889b206774895"
    sha256 cellar: :any, x86_64_linux:      "1c2bea6a7b02efc8334038b9152cfe0aa5b741b571a5d2b397c2b04898553b79"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "pipewire"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # opusic-c bundles libopus and builds it with CMake by default
    inreplace "Cargo.toml", 'package = "opusic-c" }', 'package = "opusic-c", default-features = false }'

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

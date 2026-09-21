class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.5.22.tar.gz"
  sha256 "1bba532643db452944180e17968013a2cd2d187c2a2df3cefa4e4abdc46982f7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e6f3548e9ff729ba599a7960e212b18eef6815c19f2de90aad97646218e7aa2"
    sha256 cellar: :any, arm64_tahoe:       "2fbec24449d00be2c345480650c83b3f6cc84104e38ecf2b83c5ef5bbab3273c"
    sha256 cellar: :any, arm64_sequoia:     "757083cb3a2ddfb4e28a2c4cef2862725f057a4d36b9c805750dfeed9fc58285"
    sha256 cellar: :any, arm64_linux:       "b5eeb511361f67409ac050118b9ec781b8e731e787f6443551fd41c3d8611cfb"
    sha256 cellar: :any, x86_64_linux:      "15eca6790019b05126adc617ef38ff36b2c92adad89833d27292f7e0a2462ab7"
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

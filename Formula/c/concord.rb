class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "ce321477df056448772aff022a9d39d58556b3a4a8f70d5c9847c79814161338"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e80ed125ad00497f4e0bf66afd1bbce044f07f24bdbeb1b857fa036fc14db157"
    sha256 cellar: :any, arm64_sequoia: "59dd83c57d65b0db67814969fbc0a4b16c1746f6fdd89e7393cc0b7016100bfe"
    sha256 cellar: :any, arm64_sonoma:  "608f673e856961696231006c1bb289ed3f9d72b20ab820e5bdd724e56bc61f54"
    sha256 cellar: :any, sonoma:        "be212e54a3221742382f1089b05ebe77c142ae735ed1c27042c88032d9fd3581"
    sha256 cellar: :any, arm64_linux:   "b9dd98f45e20f68230a30fe9e99eebc3dc195480e1a538d29c24fd0129cc0e68"
    sha256 cellar: :any, x86_64_linux:  "343c7e4fc1f2c30f274e644fb3c787874dfb3302dcf4ec7373484a02acee9a15"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "mesa"
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

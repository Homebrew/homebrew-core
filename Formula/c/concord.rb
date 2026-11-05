class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "c3997c7f23fa9367baacf3b27c5b5bedf1b2c6c3a83a21bbf82b79754006c673"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e189df54866771e743e45c312977e53c9efa530688eefa07d9337f72b084ccfc"
    sha256 cellar: :any, arm64_tahoe:       "f422c24e910bc1a3c113348fc7673c64238567b1bbdb6ea99c77540cf9b9acc1"
    sha256 cellar: :any, arm64_sequoia:     "61cd9c26cc65f6e676c943b44e690bb46159ee1567ff44b15f2ef72551c59191"
    sha256 cellar: :any, arm64_linux:       "3e3ed504810edd4bdc1a04b28f2b24080ebc371378c09d7467992155520c1e0f"
    sha256 cellar: :any, x86_64_linux:      "899cf139727f0c7bc23bcd8ec9d1202071fa1a630c5998b2d8a3bad465f76580"
  end

  depends_on "cmake" => :build
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

class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "c3997c7f23fa9367baacf3b27c5b5bedf1b2c6c3a83a21bbf82b79754006c673"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d21d1e656747a2268afa3b9ccedd9efdeb9bbb8abeed0aaae071d268bf275358"
    sha256 cellar: :any, arm64_tahoe:       "bc5a1f283f7de19ef561da357191a53fee4186fe20841afc5fa387931d333eb2"
    sha256 cellar: :any, arm64_sequoia:     "c4285b4e09e13a6b2f0aba39d59b750453489534b97d7c01898c3a573b56aad3"
    sha256 cellar: :any, arm64_linux:       "a16020d3d6f6253586af5a9ec4d19846661fe93dd1b81d3f320142cbedb16732"
    sha256 cellar: :any, x86_64_linux:      "b149ccacd1ad85f782ff756a5636d15061f889c92316023cd05bdba9d1809b3d"
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

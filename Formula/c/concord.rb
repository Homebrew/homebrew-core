class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.5.13.tar.gz"
  sha256 "3c7367ee741db36f7b152a9fe8d88fb357316b9990d36499604bb532e8abe774"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cb9cd34661d38fa87a7dd43068e9d991705c986d2ac28f50db27f4d7f20fea4c"
    sha256 cellar: :any, arm64_sequoia: "1abcdad145c70edc772528f03fff422c464bc625e7dc6c80ca474cf86cbb6c78"
    sha256 cellar: :any, arm64_sonoma:  "29eabeba0135bad412c5a37349e432cfa19c9ebcd90a889b32b070f7d500de87"
    sha256 cellar: :any, sonoma:        "0813bf3173f9880d1a40c43274df2c99521ee2cdbdf52b84befd476f134607c2"
    sha256 cellar: :any, arm64_linux:   "4e927471c1d3546048945ce90a1e313f82898a903e19b8b6d4af70a9d5d48162"
    sha256 cellar: :any, x86_64_linux:  "d8fb87f3283e154df7a64d14df4601970826c060713eaf9d5712fe6f10ccdfa9"
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

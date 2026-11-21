class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "f555af799377e684a3f1e4846c8087fb01d24084435efd8d6426382bc0efdb5c"
  license "GPL-3.0-only"

  bottle do
    manifest_sha256 "ea3127ad60ca6b52a089b86996de4f70a865d8c248f08c9f05a97fca70e46e6c"
    sha256 cellar: :any, arm64_golden_gate: "b22c3888b7c394caadf7c006130b9963a38fbebcadccf19cf2c753649a2d2549"
    sha256 cellar: :any, arm64_tahoe:       "ce34203e3e1a8e72774f95a49de06d95f11562ecb8a43cb2821611b0e4e96381"
    sha256 cellar: :any, arm64_sequoia:     "47d9b12cdf47535be13cb6473d9b62be3313e0b2067565a34471b3abecf957d2"
    sha256 cellar: :any, arm64_linux:       "f8d32fdb7642546bd3176a6327e119cdbad312970678fbc6488434456b116f0c"
    sha256 cellar: :any, x86_64_linux:      "65a13b463f15724aeef250a07479606e31a27558ed4d7d8bc068581a9a4ab3ad"
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

class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.5.12.tar.gz"
  sha256 "6df8da04e80a97d222febf35a585756673251b58f464e520ccc8edfb4da85fc5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "049a4194ef4db769f2afff15e9a1cb2ab8b0dce882e527aefcdd8911227496e1"
    sha256 cellar: :any, arm64_sequoia: "91e6d084a9ac02cb7a30655f8208a140668041cd201b458725b4277c57db2b19"
    sha256 cellar: :any, arm64_sonoma:  "0cf5c7e171684502664acd7b6c7c555c4589f4ad134c6959e486cddb9098424f"
    sha256 cellar: :any, sonoma:        "547f2137e9a256b12299d9b6ea8a5dbd370f712720404754d989118ff9972ae5"
    sha256 cellar: :any, arm64_linux:   "4aa78b3da21265c6714b0544e0b7d9c3b2d9ff5d3e239a52b066141d93138b1a"
    sha256 cellar: :any, x86_64_linux:  "542cd306e1ab01e3df81d45f1eee8c8dfaacbcfaa2fd7ca0dce5d45285807bcc"
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

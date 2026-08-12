class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "73591c345f3351dd466e2da424e1fc3b848bea6ae4790edfaaa1ccce65134124"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "792ef1cb3dd874c9f330ac110631f0f5985b9207c190de4b0214ed2519e02b8b"
    sha256 cellar: :any, arm64_sequoia: "de8d1d8639a84f2de4183ddf00599707056468b45e4027c3a37f7692c74369fc"
    sha256 cellar: :any, arm64_sonoma:  "0b2eecb029ef4b01a2d7e3aff93a4776ccf662b11e505ca81602d667d18913bb"
    sha256 cellar: :any, sonoma:        "4f0edc428b6e1f376f3a773f57126e16719bf691663ac04b0215d0888202fc1d"
    sha256 cellar: :any, arm64_linux:   "f7f61b17f4b62938a969aff781446126c471c8fdc11ddad6e8963ad0bf11250d"
    sha256 cellar: :any, x86_64_linux:  "e706013fcc410e657673145bb8737f210a85dfdcab98dc31a2f4c4739e1ca8cd"
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

class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.5.16.tar.gz"
  sha256 "e5ad35f6ea14ac4b16f9c44d1119d4513b335885ffc7329c55a009d17801b9f8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce9f14b5b7af30898aa9cff5b972e2adb221f21923c9c92ff1bc110968960467"
    sha256 cellar: :any, arm64_sequoia: "d640653a2156b9c8e78dd40ffc77ab4569d50887a50d9c45776b77dcc0b04b06"
    sha256 cellar: :any, arm64_sonoma:  "ba9376f0a087b5b84e45d26a801ee8af0a465a5a742834297e29180bb9e0938c"
    sha256 cellar: :any, arm64_linux:   "84570f29ca8b0ea71028c1f313d3f55bbb837e7b4e71bcdae0365e5413920715"
    sha256 cellar: :any, x86_64_linux:  "041807fe1c41f852c7cde411e81aee3596d9af104006b89ba15d4ca5c3592939"
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

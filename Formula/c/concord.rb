class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "de1624f460b1fb4148256d7b9141bb1ed6b9cf9b9e3b05fd166798370f35e031"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83f16434c2df8c017dd7707eb0d13d1add685320550bc7a97849da270109fe8c"
    sha256 cellar: :any, arm64_tahoe:       "343e1ed0b601a0a7e9d7bc2e2790434a9d41dc9255af8fae7e8db843a17c58cd"
    sha256 cellar: :any, arm64_sequoia:     "255d6803d14d2df6498fe7ee125202d3f2496880e0692f6b675704b7d624c2b6"
    sha256 cellar: :any, arm64_linux:       "062f9cb2ed1f8726e5d5451dccbfd36f8cbbcc161cde12236dd394281a52274b"
    sha256 cellar: :any, x86_64_linux:      "b2caed0bdb7e78d69179e03e7e19d2f652c00f723d79aff3de85d7a24d95edb3"
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

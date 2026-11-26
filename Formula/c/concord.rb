class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "8b87244d31d1e0eababe59498f3a2c4ac294af4503948dbde447179b8a0b31a5"
  license "GPL-3.0-only"

  bottle do
    manifest_sha256 "192a04daa8599dfd6717c0803935f4112c21340c70a612284baceadd634574ed"
    sha256 cellar: :any, arm64_golden_gate: "0230d80be73a5cddb586b52e5f59214f40e867fa1e0ac355d9ea44a54e8170b4"
    sha256 cellar: :any, arm64_tahoe:       "4a7da09e1b12bd548e9836a5eb37032b1a15bde2088ffe3296a3a7e21ce602cd"
    sha256 cellar: :any, arm64_sequoia:     "0d8d4e07b845b671578865c929dba24a61bd77dc1331cf389caa099a3d0f07c4"
    sha256 cellar: :any, arm64_linux:       "1b93df1140fd09567d88a27418383c22b8a6d9bdcdd387df9b2f08b5a87535e1"
    sha256 cellar: :any, x86_64_linux:      "11af6d7ffde37ce2394a60366078ae12ca334b99f8b254cb17beceb80dbb1288"
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

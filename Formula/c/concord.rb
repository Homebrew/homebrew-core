class Concord < Formula
  desc "Terminal user interface client for Discord"
  homepage "https://github.com/chojs23/concord"
  url "https://github.com/chojs23/concord/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "95588420f3a4d6ebd9cfb2def7257c52b89503f132f8af61330661cf0514cfba"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ac7a05469b46504bafde2cd244b1a7a2b5d9529c8585ae5b89d6ff8d8b8f476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8edb3ec2f895287de13f3b390e3af39f17d3b386e75e42f4396e914d3f02d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "544ec124a903fc13193002e7298b2bcb80d1e8801cf610f3b7ecdace8e54d91d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51458ce5224c4037d40ca6c205d0b95fc7f67e8d2f34865e7543eb31cf8d646"
    sha256 cellar: :any,                 arm64_linux:   "d18148b1d7358e85f132b72c94fd42175b5452fe6a23a1020d94743055ff3f3a"
    sha256 cellar: :any,                 x86_64_linux:  "8570769ae6f2246ce1954724dc36660198f01a0f1278c60acd00c904a0fe2744"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "opus"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
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

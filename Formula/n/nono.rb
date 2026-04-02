class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "f9aab1a1ff966b2cf4987aed41d577f188d6bdbda2d6564368491ee3a1f91627"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92471fbb8c7e3e44866f855bc250d149def45fdd8cc3236d95eaf906dd9d4f4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27c30f97ab04aa4787d5be7b4030889e914b990db0cd3cefe403ac96e159bba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c20f734494325b006b07486f88b59f6b262a87275909753ee2452e1a39997c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6bab5d5de7c23806d4e5824ff738c98ef8f6a733ed465693a63d6d2a8b71475"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6a08bf36325f22e60df9aaa13c5a34d41d7f979c9e33b999adb6b0240a7a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062da5cec908df7c60b5fa80b5c82663f67e713b597537c6d39ca3d6beff3778"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end

class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "4a7a53cb75c7102f42e3575853e7694cba846622b016a3adb97cbf0e8bf0b8f0"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4932ae8e2129f79bb34bb1bdb9c575c9d218965bbc07473b81fa9bddbf2c8ea2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af807bf094da05ca13f50c008b2f38590f44327d45d579b101b03f1e8b7ca59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f546737f64cdf17c7ed5067aae197aad0c38c5e9c330492c8113f08c29ddd2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48c312f8205cae731228628ae9f1939ebbf06b9aa7ea0ea2859b12cc86b8ead"
    sha256 cellar: :any,                 arm64_linux:   "a78dddeda7cb1b8a94376edb4f4a0cb6bf34f9cd2a6f1da906c572a270bcb451"
    sha256 cellar: :any,                 x86_64_linux:  "29707f2b347c8316887ffdc4a4979508e3a368b3eb9016a9b35022c5e05ebb30"
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

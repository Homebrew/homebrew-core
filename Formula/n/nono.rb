class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "1c0ec34a4eeedc0fce54c4982cbd0a871bd7e837f3e4567537188cb0de7bfe62"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbd589e5017abea1e426812e38ff6605af880e2f05ca90a8921918b5ae8fb7f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44295537978312e68515e951431452a6cad93b19d8afed2c5343b089b9c7936c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9d4bcbe2de1b5a04fa8ef43984102232b9c30a26d5b9f3e720581833350a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c14494fe966b2616140255f3fbcd5769378d1a5ccd781d31f705f641ddc7c44"
    sha256 cellar: :any,                 arm64_linux:   "5d4ca58881e9de5ddec5594bad063106f97c52a604ecd20dd1a544ef1aa44456"
    sha256 cellar: :any,                 x86_64_linux:  "d960b52752e2e49fc14641e148df8a607592e73dbb8662ddb4055f0eb3867397"
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

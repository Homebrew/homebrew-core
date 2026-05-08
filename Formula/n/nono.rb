class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "2929542ce31d4ac1a9c14779dfc5b6cef1b2e2d6cd573fa60e452c6addba4078"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84e291401b0deefc04e76bb1ae5fb51ace623f9f17c836c6c7ca09b7084d2a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597268be967523708836fef0b376bab245f93f32eec214fa230c36a060d1f8c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef27b113e135663f66d663d80cdc78e1875a56948d2ab871da6b34d97cc2cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b132c81ee1721fd551949c8fc439b19aa7ace8a3ed21a2696173f4d03ac867d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393d3abcda2b6ba4527f57f1934d938dd889fbe23f56dd4c6d6a5d3fd5e9fa79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1c7c649613eff1633d9bdaa79b959c8c50e75c83c2d6a81b278e76f73916de"
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

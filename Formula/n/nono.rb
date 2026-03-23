class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "0df86ae8158d963d9b0b2c2f077985fd28f59aa92d980ee151237bb73eae457d"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53d936a94ba87d080d98b33b23dbda6bb1d0a613e252f38dcb682d2830d66d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8afb8e5689c7c1412a516aa8756b8630e74802dd3a124a31919d58d1f347a8d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f955a6a572eb25b9563cb7551ad976a78e9c72f9f245b64b610842c89d388745"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1fa3c0d75312200e541335f577113aabe4a341487624678f0cc340645affee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2cf5e7460fba0f057b863814988fd2a476fcb06c57847ad5d30b4b1bf28ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac3d39842570d63a8997cd21fe210de326c3b5fdea54a65aa8eebebdb02c8054"
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

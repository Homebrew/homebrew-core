class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "40d216f77f9b0a787ab8abe473a565be7c3835318095f19b57aef9e20cbceae2"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a13a8d08cd4163dc7bf06bcdd846187ccee2c25561f923a01b8533967ce1ee31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "961b8a4370581349be355588d301739f2f29c1fa227135fc69d9dc92b14c5764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af668098a2f19501b848084e2b05cb0baac5d17a0f07d509662e27081b3d0ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "be80b11ccdce38832dc3118593342415567bf20c0479d871f4fcadf12297d3b1"
    sha256 cellar: :any,                 arm64_linux:   "217dde2ac842ddaf82425bf939a0168c669b011daba2684c40fcc0e3f81a594c"
    sha256 cellar: :any,                 x86_64_linux:  "461b1439c27fc25e824727e4c9414e30dc78e380c5d86632f1e0ff420f6fc684"
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

class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "50f669da35a7a7bcaf5375f9693a2e3f37905526da77aa38e8e9b71c081f6d6b"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c138b6998ae1ddd17c111f88fc9dadc1889124a0b46de309b33b83604d50f390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c03ac5dba375559739934b9077a7b0d826a54d153227f20336a5f9d9d287837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f4b1a10a27dff1faa18d9a6c504ffd659b55c57fa0d54aa016726c80c81673"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9b83d42b54cb3ea2f185970d36fde68e031544de4e6a890b8b594172a5ad46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a014cc78cea82047f5eab18a2765118d979a0aeca4ff3354898f241d3be7229a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b1c594b7a7011146aa867d840f80ba92ac68b0b9be8aa830890b60127421689"
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

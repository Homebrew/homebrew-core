class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "eca9a027cd186e595824c99cd8bb88467a03619fb793ef7c249993fc771fe1ce"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "534feba1a079bad7006b93613cb5f2b95591d42dffe078697eb07f74a6bae6df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7fa775510dbaf1fff06ce434c99b57ca3237ec6dad3964793d41aad692b2e9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e34dca50ecac578ad1b22106909318a73d28089cf597ebff0d46fff68e365f41"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0189285542c24bfd43e2d27c602f8e02307ac9bdeebebc9767890dc1456d22a"
    sha256 cellar: :any,                 arm64_linux:   "4fef1c897533c3d3885aa9437361b875ebc520e6cb9fec0bc22a025a0b93c401"
    sha256 cellar: :any,                 x86_64_linux:  "348a51b695f415fd05e83f0a7084062a77252ea0f78ac5df0eeb724229cecfd6"
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

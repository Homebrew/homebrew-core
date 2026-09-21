class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "dd7f50c088cefb4e5f005d80b1666bccfe3f8ce81a2ae8e825a1b3ba98736b06"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0831015484ba60fe392cc7fd6dbcd96bc57c73d9084166cc0105343d612b6dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b320e6961bd17e5a2cc7bb2016c5bae7587257c1007167210b9285a699a436b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcdcff884fa11ebcadeda0682d247b67130bcbc342df3d97f6f7d2df9350de78"
    sha256 cellar: :any,                 arm64_linux:       "8238764c0df949520dbe7b40075be05c40dd1a7c3a6999fa755dbc46c72bd00c"
    sha256 cellar: :any,                 x86_64_linux:      "24d267b3350472c6968e7644d4e0ed697cb2732eec7e6ae25ac89c9d67aeccfc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
    generate_completions_from_executable(bin/"nono", "completion", "--silent")
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

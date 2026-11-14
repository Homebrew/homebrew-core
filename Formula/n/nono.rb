class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "7a2db3faa14a6218d336d62ed14e0447a9876c3a26478dab25854929774cd680"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f967da993312f04e48cf13c6a694aa21e527f7fd77a38c50930f92f35f4c685"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2294935f6aa1e71ce68fde40c4071969c96caced4dc843ab4943249934ac6fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5213e4307878ee86eb238660848aaaed066a1356b5822eee148e0899729fcb7b"
    sha256 cellar: :any,                 arm64_linux:       "b7814792a711fcdae0efb0a1eb4a1086f82cc1681f53f035f7cc5afb0be5b63c"
    sha256 cellar: :any,                 x86_64_linux:      "ecaba66bcc449544dd041c9d62cdcf28290a906439ef528bad4b1d379d72302a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

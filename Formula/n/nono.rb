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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b2561479b9f4511afe0aaa0f31a750924520a55fdf55f74e57e77d8fb47fa55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc941ac53eb2db39d5e7a9fc2dac8bd759488700402d2940827309f56b12702a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40f98cd85f78f366a4390ff181963afe7df01fbb0263d3e5163509883c0b1563"
    sha256 cellar: :any,                 arm64_linux:       "63ec3073004c8a51b8931c569012c252e91ead81673c0c4ea4bdd0b10fd0b63d"
    sha256 cellar: :any,                 x86_64_linux:      "55f7ca8e5430cfbfcdea57974818df968f2de5bb250cdda99b2f6c5cf7b081ac"
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

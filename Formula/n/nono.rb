class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "e3af961a0993644c2bef7676b183cf7af67bffd3488bee272e315e8aff83002b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6258568f63774b692fc04539644b8d92faf3439f88a392ab4ca59beee3ee386d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0d8377a374e5c4c8d3823b53bf22eb88921f82a65bf889943a4128447f3c3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47bd402cdf6c9f8f9b914934ab7dcc514798a86d843692657c37612a5d4826b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c09f0e1ec17c744eef363dc108fe913f6d437741c048b68924d35533f83e0f"
    sha256 cellar: :any,                 arm64_linux:   "0a2b99ae04d4dc1573cf5df0f2f3c56d1f8865d73e792ddb272311c5f5578834"
    sha256 cellar: :any,                 x86_64_linux:  "402d0bd7ab53d0be3e9d3e8c5a4eb2b855f5e7d94fac6a43073b2f641d29194d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
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

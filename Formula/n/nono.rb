class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "d216e714883f237a5bac468a0141dc781a979eab2535957f63ecf27a1fffdc09"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75dbd304cefc1242d7b7361b3819d50b997fdfeece82f2bc30d339bd46ac441a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "828d10db162ec08ecebad5d55e878ada6da7a37d99e1e840a1309f41dc9f9bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adcfc32152419932bd25635447d71c2245adb073db8a88bcb2fdf2e3093b6aa3"
    sha256 cellar: :any,                 arm64_linux:       "f86ed0d3b9fa4ab7904ce3850c3aa0ef4cb9fd455b0e9c54ea45d7ea6a1cfd11"
    sha256 cellar: :any,                 x86_64_linux:      "03bb90f2a4face44ba35dc120caa7f1471d947885de12c2acf14b0fd1bd6e966"
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

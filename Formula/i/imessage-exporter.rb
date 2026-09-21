class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/4.3.0.tar.gz"
  sha256 "aaa19f21a3144bf9d115ce02a77a988bfdf3485fcd1d35cdb9ac4c81b86e2400"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a13633ab4c670dbfb2c6e7269fc2410fbdff5f31be637cdd5f52e6fbaaeb08d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b884f25e96bbf1670744f467cd03b3cf793c2b289969693292cf2641c0ebc287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebbf4b6aa8bf6862ef6d41d9a7e3db37e950f5565d3515622ad63e602eff962d"
    sha256 cellar: :any,                 arm64_linux:       "407f84f51a844aac366ca5834d4a1323417690d7f4a92402f13dc26decbd2902"
    sha256 cellar: :any,                 x86_64_linux:      "ea6c0a4623f60c146c9d980e66408a7599fe8c317a1c3301afe9a2f5e873844e"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imessage-exporter --version")
    output = shell_output("#{bin}/imessage-exporter --diagnostics 2>&1", 1)
    assert_match "Invalid configuration", output
  end
end

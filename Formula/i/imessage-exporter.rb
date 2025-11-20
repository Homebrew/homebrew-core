class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.2.1.tar.gz"
  sha256 "47292831006ddf4e6970bee08cfb477f10548f7a2c1ae8972aa39ecec7b03140"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f640f806449d4daa1b1f82c7fc5ba3e1ba548c843d45482b046c8da365da2d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7230acece3e4a8bd5910e9351e30c6d7518b85945a09ad96d8647c501af631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7898ea0a43b1ce283eabc97d00f3b4ff82048a9ad09d65cfe0c26e99df71113b"
    sha256 cellar: :any_skip_relocation, sonoma:        "27b44a0a3208862c12661d8b346c954460b09a75b4a74b0459807b809286ed27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c04f0503c43d30efa0ba5a8a3b88a9e13f7d5240e49f517c8c9d9904f632b98d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc6ba9cd00fbb4c77111c8cf01194d0fda4a5ae089e603b7ac8614531f93ba8"
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
    output = shell_output("#{bin}/imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration", output
  end
end

class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/5.0.1.tar.gz"
  sha256 "4c1f3ce78b36547c68196a5d4557b1bdf6864e3cc542930b523938d71985a1a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c387d20eb047a541f114dcbc23bec32f7cf846b62b2d5bc803df3a745a5634fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bca89660d3df455c6eddc0f2ca0a70f4b40cb2b7a5aeeaf22273be47c6ed6d71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfde0edfde7c933affebd47d94440092197ce2aa068606ca50a1738b112fcdbc"
    sha256 cellar: :any,                 arm64_linux:       "01fe1303be39b21abb45e86ff2f1f1cc0c71035ec9e2406474dc19df2f1a2b8d"
    sha256 cellar: :any,                 x86_64_linux:      "74dc16d6785c5924ae83e2d15a028d757c32b223b78a3452b9688edc69560e4d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

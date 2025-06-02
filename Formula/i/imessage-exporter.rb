class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.7.0.tar.gz"
  sha256 "3547b0d2cbaeffff4902d041708baa303e09fdaa05a7093f82d942c9b739e732"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bc0a58419257c1785e8d5dd3590c7093c2464f5abd71bede30095a53645ef9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c06cd8b3fce163217727ba7db8b9b1faed06dfa614f4aec4df354506761d43f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f50f24ce9ac8fec391173cfe6eb2b9319e3051bdd6c417a593f2d94e49a8df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e4cd22ed236e181e042701aacce339a07e75cf70d0a2f083109ce64b2e906f3"
    sha256 cellar: :any_skip_relocation, ventura:       "0b59c176198ac3a8b4f13f8d889fb5d9ffba6b1fc68e70416fd0f5e25339ed74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37c41ae5ddc563338dafd5a3964f73a4865ece530f62d4c99b841c4e41c9ad93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3686f45f3c8a6e5ec9651f6a4b92ff03a075c4ada8cd10b47a2ebb30782d2e0e"
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
    assert_match version.to_s, shell_output(bin/"imessage-exporter --version")
    output = shell_output(bin/"imessage-exporter --diagnostics 2>&1")
    assert_match "Invalid configuration: Database not found", output
  end
end

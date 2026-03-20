class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/4.0.0.tar.gz"
  sha256 "a2c036d38e71e5faf289c5e1d22b488c6168fa954bd2f8f8fef487d34fd6b86c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c90aa3eff74a7c7602a910b3c3c25ec343123c803c2c22c51102f8c7acfa38e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c8e0406c2405bf9cec0b5c47fd98ed4f1e300d9646d3b058553bcfaf69601b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "074a16191c1ff8fa80c2af90ba5817ab0d70390711dd8bc3bbd71484aae9b98b"
    sha256 cellar: :any_skip_relocation, sonoma:        "884ae14854a220c76c2ee15f675da76cfe9dfd7b08705dd9afc35148947e0884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f45b08bd90a619e7172e35b13ebe613449ffebe13136c54cc1c15c90dd738e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c49adb1425488354eb3617cd71f5114a8f70e7643f2a77ba11a49de305bc43"
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

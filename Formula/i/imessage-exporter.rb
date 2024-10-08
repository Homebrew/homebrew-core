class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/2.1.1.tar.gz"
  sha256 "ca3d342acbe803940f61efcc06a09a8c94d937f005aac4fe8ec6e8f9c61c4a1a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03de24df7eeccbeecaa32df60f5eb3b5302bd380b6d474ad26628284f374189f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5909b18c7dfb980498e9b54e9cc4ae28f0e8121d43367875ea712dc2dcf16a4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4880bf1c711023b843f96a52ab19da091156ee998964c36754734f933440d7b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4303a5056fde1b4daed7a2d67fde4cb81397c1353f8f1610ac6ca69a807dbbb"
    sha256 cellar: :any_skip_relocation, ventura:       "74a410cb727138df9e1b1c774e49b3c63c945c5570f031c93bb78636701aca4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95bbedae01c3b88f46bc1e5b45b720fe36947f0c865988d7b0cf2b5c8953e2b1"
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

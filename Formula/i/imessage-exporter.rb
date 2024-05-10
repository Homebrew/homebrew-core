class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.8.0.tar.gz"
  sha256 "59ecddd92cf995396efa779ce7384d26b38d983e80b3d590c7b776b350350b96"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae5832043e909856a6d807a5eb2ad67ce6f4709a5df98e2497d4b07676f27bb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58555d3d116f370b276446e790edaef01995fa8179c97398d84180f4f5c4cd5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "797222f170dfa48b32fbb45b6acbb79bd3a3f71c62e48b71501264a090291d0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcb88fece06ebd95894606c4f6aa87007d26ebc10275dd056751e89f5b55e83d"
    sha256 cellar: :any_skip_relocation, ventura:        "b8dbbc862e356689a3f68af7b7cd330a44c4f46023dbe4333c16d396239f50fd"
    sha256 cellar: :any_skip_relocation, monterey:       "12c6eaa2cd2f6c6ce957eab3db48afd100768aa4ac84add930dcd20dfde3a3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f3fae2be6c1990d5bf72309f9ac35e7edfe8bb6df13e95904e4fcd46c4e408"
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
    assert_match "Unable to launch", shell_output(bin/"imessage-exporter --diagnostics 2>&1")
  end
end

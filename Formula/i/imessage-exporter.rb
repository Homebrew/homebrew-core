class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.3.0.tar.gz"
  sha256 "db531dcc66d88e26f7b430f62fc0f9f089471912466d8cf95f2b11522d69e735"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aef467c3648c2f41594de410c0eb813fba664b1d2e7e54f4381268d2bc04b675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ae3e2b1d6561f6366638141aca78953c7305e2bf5dea210911bb3a744fb4ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1521a77deaae5b91836fab92801d5529e30eb7af0999972605aa13451ac002aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7deed6d473fc2f30007b42e1ed779d86bffdd7e09b22a2271577e1106d3dbb6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235a1a7bdc1b91c4d4cd51e9475ff6224560cd402a1e0c2c352951a25e5d7896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c1d2d7d6829903bb60b54272d2405cac57504642a4d642c31bf73c6cb73d1b"
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

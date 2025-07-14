class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.0.1.tar.gz"
  sha256 "fd661f86e46a0940b22d6ca2c42983d97da2ccf5bc0c47962e8287244bdde1db"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e74f4311ca7af5df6a88cf1e794dd54992c861b61b1c7556694febea2fc7c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "550356357868889a8cc73757fca11ebe231575e7548d07966015b7bd8ea7185c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d190f66454234a72f929d78199c516ebf5a8e75a6526481133fc55160eb0d2b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe44907cb766907af7be5165b98542421c0ac28d526187b9e561845a606714d"
    sha256 cellar: :any_skip_relocation, ventura:       "3adebf07736b3cee6cdb0cff354c80aff27331d7637c4a38d8f9abe6e0101009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b0a39aff327eabbabd0868295234bf971ff956428f37df00a2392ff705b0b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ceb34fde10955d90a53677b2ee6953ce4850761cb3e59d6b73f30c03a9bd80"
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
    assert_match "Invalid configuration", output
  end
end

class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.5.0.tar.gz"
  sha256 "ce92f158a414451f8edfe88babbb4e694ca685bc24bf9c84a5f4de03eceb0e02"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57952d693c97e01db0c8e9fe35cf82f6f00642280ece1a288e3adff5456a66bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25af1c8c1dce0e25e92d0b5385d726f0443ac6fd4435a9779459839ea11e3b14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c1231564a3e12fae168bc9bd0d9770fd7c5bb84d2e05756ef6628ef18cdf18c"
    sha256 cellar: :any_skip_relocation, ventura:        "bf94c53dc5f58bbf12b5726209e4e7b6909c1ebd15ac9d831206de74d00f7088"
    sha256 cellar: :any_skip_relocation, monterey:       "98dc3d8bacdfd8f7304714a78d1855d033ed73a18eec7ddb7797739124cf7fcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c54afea110a8035f6186ababcb4516af2113fb7a5221804f12abbd0a4f75592c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5626e5318f295b89fa768787f58d7342d9188b49f0296ae423563bc28ae06f9"
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

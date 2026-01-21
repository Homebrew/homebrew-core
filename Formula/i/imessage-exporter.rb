class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.3.1.tar.gz"
  sha256 "703982e646596dcc845aed2e6ff7c305b022007b39e2cd9b86169722be6e830f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc820767e57ec5ffc144dec5fe9fdc2e813155cbcdce81c221ab6575ce7f354a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d8e6d99172186cdc996191326d376b957dd18cff38bd9ba5f24571955af5f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da75753f08922b4aa1f18a6e2241a99919486571313fbf8442250ba1d0724d6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc670c206d1e868db3c4ecd3041030a8079d4af7a118efacb23cf7e6afc8dda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35a2203c3fa2cddbabcbc8cbf273ba6acebd8eba869f65185f323174ecdda6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20a219b8176f5d9c06c320647eaa4b7d9fe570e8f7459b9dd0375be542b527c"
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

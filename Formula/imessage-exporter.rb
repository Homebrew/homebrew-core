class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.4.0.tar.gz"
  sha256 "33a3cd7b2331b8ad2d4fee23ed0d6fdd82ec1f4661db3121a4fa2de6a9413fee"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d37c167d9aa451df59b0f05ae847291b3cfead6b2f9b99802b686de4a4db8f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1f754f2f5b72ae9213e5cb768d46e802cc095d6a747542c7ee9ff5175c19e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64101da445678c89f53033e0584eb0036bf5de0b2c3a5a0c83f46f0c34e32ad9"
    sha256 cellar: :any_skip_relocation, ventura:        "f590ffa68e11f8d41e156e0d4bdb12207f854c41cd56e1c5866a8c056a9383e7"
    sha256 cellar: :any_skip_relocation, monterey:       "e437b03d2abd953ffba20dff60c55e03f7c156264980c7705f1720f2784af3c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cdf7615c29ee31fcfc088b51844f5a81f9e07cdeba1b3b01f8210062fb5499c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b577f02c817b9225517c2efbe28684bf5ec6f29d58bcfc9fd130def9087c53db"
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

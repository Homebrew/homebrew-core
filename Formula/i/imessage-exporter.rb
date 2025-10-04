class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/3.1.0.tar.gz"
  sha256 "813ceb7eeb53f6cb526341217209e713c69f81d157b32fbe651083b866342355"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0a2096f51be33884547babee5fed36c73eab85720d396aec63328b75a7047c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6566579f7d46903218cf81f693b9f5c744846d8e0c67e8b009c22d92824312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d03ba019e29e8e937b1ecc3690c625a52955342e9e778b4dd760e216bd73d593"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d62633bd31cc2d4bd3e62ac6016055ae731654b6b026b1cef8f62ae2d297f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dde68f86fbe5c62c807eeab7650aa4eb54f48d73c6cecf01891a6e94cb304dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a5abbcfff5433efa34d4c88eb903a8bb201f8880e4a576b760e272257467e5"
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

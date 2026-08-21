class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/4.2.0.tar.gz"
  sha256 "3b5edd3d3e5387c96c44bcfc5cb21702426d816339091d100323a6564c6962f0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73061b9f2c1e5141469e5db62f61a38ab947cf194c140981805dfc8188acf2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5b42547e4fed80fb089954fcc09a40ad2120be3e135329d75f90693dc6aba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50bfda58d4f7e6f0f6e42a93a639b18a9379dbfdd369c45ac8005d679b2f6169"
    sha256 cellar: :any_skip_relocation, sonoma:        "38675a4d99a31f22f8aaeb035afafbd078da6325b6272df3d8bed32f75a93e3c"
    sha256 cellar: :any,                 arm64_linux:   "7399e3b6a6e2337eeef9d45f78719d19dba2df8e6ce913b06e55ef36d5ddf670"
    sha256 cellar: :any,                 x86_64_linux:  "cb14d97ab80246b437302d1ea2ce9a47c9b42505d020cb367aa51d3f6e29010a"
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
    output = shell_output("#{bin}/imessage-exporter --diagnostics 2>&1", 1)
    assert_match "Invalid configuration", output
  end
end

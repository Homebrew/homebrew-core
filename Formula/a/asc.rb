class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.29.2.tar.gz"
  sha256 "dd2702177c30d19de3855279014af3bcf9b778bc34d18293c2166fb9bd762f4b"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f0f5ad90b5dccd95a5ab15f5f821d3dad88418cc963b1391fa70e442c372ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f01a38cbc014ab79ecb14503430d7751f655b0c4ca6ae57399fbe7771e3fe39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ec3de05f18df9b88a3e1bfe71af33195810b8a27bd40e92155bf443a94533d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e3a499c4fa49bccdabaa94f9981b7b85b28bd2d3944d1e93b3a302725cd286c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f302416042067eaa404878bcc233187b9c3959898795753f0af0992cc9da5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6bff6ad6be5000c2be82c1e64b45734525672dbd742cc742298b646b3bfce61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end

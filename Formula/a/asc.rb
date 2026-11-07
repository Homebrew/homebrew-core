class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.5.2.tar.gz"
  sha256 "d1221aed1e18305fbe8e018ca42339e8bcf4e7a84349741c06bf6028f1821ecc"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d99d62418a7cd11e3f70b888e2ece3e46eb494b5239699a9efa29048e129d942"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2a220130acdd66ac3f9979157bd232a8e91df1343da266c7b152b6b577a1469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f4a765a635063e7c97d68452d70da7cbae7d977003a3e42e35649f2f06ad9df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e249413aa993ac6625bd85ec4dc54b17834195117d735d0cd90bf3b9da71f008"
    sha256 cellar: :any,                 x86_64_linux:      "f1f0491185a57d06e85f9b1b842788bdfddd14e15f207621bd6bffbb2ce3cf68"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
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

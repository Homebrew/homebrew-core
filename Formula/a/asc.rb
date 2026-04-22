class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.2.4.tar.gz"
  sha256 "3b450893c628abed3969e17a504066119451e8160320cf03f6ff3d84948acb12"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d029f5a56ea86eb5dea9c297838e7bafd33a46347c6faa79750dd54847e6727"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c036c73c5d76f0b90741e495545e2cc03183db977d2d8e5fa595f75f72d0df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51fda5af024f78be434626e309d93a6e67e428122f164d48f39c46e0db2cae87"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9688119536e7da7963acd16596c9d55195e59466badc7cfb452bfbfcf8929eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60ddba763a5a6da3c713458e26c8250a0e4eb36ba484820b5851bdcd30c9d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff55863fddc8120e3c67f494e66d8942a4e6331f824d0874af7469f980df5004"
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

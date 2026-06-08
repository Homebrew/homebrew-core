class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.9.2.tar.gz"
  sha256 "c318ab42846f314c4f9b84464375c9b71b6a9017a70fabbb5714757a964cf28b"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a75b2beeeaf9f22166ce332ec700ec3f1f75dc92d46cb0d78d203ffb9b03a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac9e886e66c6111c460cebbde3a8e9bbf2cf24ebed2b50f72f9d8f7e3bae1f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c17bbd456157ee0cba119161f42cab019c0bb9d848e97f250aee359a2525c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9564bdb387e6a6f2d1cc16a2fefc1900c5d2f6a16b22e089b9e3218b591e674f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09b3284bdd0ca6793c24f903bf79c52a7d909ec05e5d7dc979be8a85b8906488"
    sha256 cellar: :any,                 x86_64_linux:  "1408379a2dc6761b57b3216a986f0deef08e1e2d5cc7b4a230cfe619bf532bd6"
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

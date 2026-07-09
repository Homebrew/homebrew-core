class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.6.1.tar.gz"
  sha256 "2ecc0856cabc1a32f2deff423219c129304f2119edbc08f6fac78b50db1387c3"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef68e816caab2af157b97e7210e7ec460146d5a3c560ca138bc09c490afdbcac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f682076710e253d906126357489a3f85c3c47d2fd743a879b966b0e2ee40f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e372045da3a1e17e5b78cd0f490aab36d01aa6a2c40f395b8c85c216bf6f88b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aaad40a24c7365bc8d5508c7369d8cdc6dcd6b8964135bb7b3dea468c8b786a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a48f8cbc85e14718b5ba1b426ef9ffc68a4dd699b46a2f9646bebf488c62a609"
    sha256 cellar: :any,                 x86_64_linux:  "92d00d5b89110e8d108ee3453349a64783e6983f8bfbfe6d086d24077b18bf5e"
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

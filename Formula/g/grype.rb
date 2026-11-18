class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.122.1.tar.gz"
  sha256 "d801d084d24d19cd916a3cb4aaa1e12b26833f50698cd968c9ff815a0e7839b4"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0701bf0f2f469358478ff7072961f3505b0b5acf102d19f9482439fa20b04a3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "354a4017805ae7529c1cc71073185a0112e33dde0c3a8c69b4c949ed6338d1e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6bb6a64f7bf9670d6651f4e651fa0279ee9aa1da277f38f6bf7caf336936241c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d7ef7d7b824daa4a2bd0917bad50a60e8eb798ddb9b4fe9b7c80820351efdbf"
    sha256 cellar: :any,                 x86_64_linux:      "87b2939ffddeb0e1a4f1afa25b010491fd96ace39c7e00f842758519c74316ed"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end

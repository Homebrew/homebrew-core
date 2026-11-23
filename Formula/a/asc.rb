class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.3.0.tar.gz"
  sha256 "f5363798ed709e9a69249117da4148c8297a07eb05ef9d7ba81485771a16af44"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "b9feebed2d880dd4cbe6b9aec3ad634e070d9f9efe2754053eedc8a734e7df0b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd3a7a89b924de0a6d95cdf5f5c67ba2ef280226f075798360cd7997dc6c7024"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d965e37bec4dc7b96930fe28b24ae877ddb6629b51827ac97e78066f90449b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b8d1ebb9b756ad51f3e7f30358162d632c48f95e9a42fa0890f72dd81eb6031"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e60bb1f6a4bffe8fa1d2efe9fdfe31f52ca98058c218d90f239d50a0a2f33c8"
    sha256 cellar: :any,                 x86_64_linux:      "5068a0fb3c8eb5f814be7f566b769b2db438a70bf267adbc1894132f6118e15b"
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

class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/7.7.0.tar.gz"
  sha256 "d87d7041612a0e1e9bb2591589643446fe5e22e1f65efb273f6c0a1ca30e75ee"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    manifest_sha256 "06a8b13bff4cb0c09435ca1e822fc72ba166510736fcfb79777f8aee7e2f4f90"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8bd7ed3a74c836bd8e8b1ced502fb296c92d644e73a6b2c1ce04e41db295f7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09362554202c62830e8f8f66741858a66ae4e7cedd1e7cf5da7884e9f8a0eb7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dcb2cb9f78e3d179ad2bbf8f83b3190a89ba4f20f5b6180cdf27ab9570658b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5067d6ee682e02d7699e51b5062cf1b84a1416bd42071728f0b923532bca3528"
    sha256 cellar: :any,                 x86_64_linux:      "d6dbf1ce7a93009c7dcd2305f3e0eaf38c7d030b3e452efd18c56bea0b9ee6b9"
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

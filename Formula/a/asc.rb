class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.6.0.tar.gz"
  sha256 "11cc0c975a246063784dc94f1727f540539c0c28c934c1b4cddf089836510254"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "327604bc45024e761e963ae290cfc1ffd984706ea1d32498c7a1b8b66967b7d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "213e8512147720e8e3dfeefbe996862017de5b9c611e25bd696792e30140d376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f865a5952b66c8a18ec36798a7a3e228ae3913e6d9d169e463cc0a8e84f6d82a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5829d73489e52d19c239a38f456de86ae7843f3f626b164e2163514623397b35"
    sha256 cellar: :any,                 x86_64_linux:      "c77c2469572d76a6cae8d0149aa585225b2520fda44906b7e0ec9dbf49eaa201"
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

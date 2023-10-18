class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "59207c63be94edd3933609c3ccbcc0ec6f139029d11a4dae64ef1882efd1f3e3"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4edb9673c6435afde39de104c7d7cc6e32ded7bb2421c753dbef076c19c5b2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf84dcd5fe73c34c951221da54d50f3785485be8d81738b1fa748f939f362ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f47dccd41832d7a9057b1a5b37a44de30e0a1d6e8afd14b97c611e68400e46b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7447f037ea1e035b0e07091dbba3f787dccb25db5fc1787ec70609a5046e158f"
    sha256 cellar: :any_skip_relocation, ventura:        "2ef0c433589da0679c2a4ffd55216da66f60606dc3f173b40af9fb6e2dacd880"
    sha256 cellar: :any_skip_relocation, monterey:       "d9a386ac6f09cb3ee657da5edfc38303969d2e72061fca09451021feba2ff4e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73dec3e527be2b497199304ba9b0c9027c2ae9cfbb6c41273ec0a0cef3d21ea0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end

class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "d9d60f4d5fad3c8ea6bc33ee278e5be8f2bd63707b12745245084ababcfaeb2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e54e59a7e099aa1bb4d7ac828c43c3e9bbcc3884eeda51c8116735773ed062e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c60ac1025104edc9169e9f3f3813c14cb384005547d7ce8a9fabb3657a2e1c89"
    sha256 cellar: :any_skip_relocation, monterey:       "6012555d3ab4dc229d61df22c05dbd92283120073ea42176f38357bc025b2631"
    sha256 cellar: :any_skip_relocation, big_sur:        "9573f21b55efebd5899cec6ab29f03473a73d272699f452dcf4edcb461daef83"
    sha256 cellar: :any_skip_relocation, catalina:       "8e25ceab4892f5e4eb4853216794f0231bf9f6ce086b961d9054806e24b84e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c62065e680745285c557cdc21f4ed142f93aded0fb94e3ccf5267b632fb420e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end

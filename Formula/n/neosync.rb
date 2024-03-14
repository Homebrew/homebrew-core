class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.55.tar.gz"
  sha256 "8135cef22ebaa21794678422a4a0d15bf17498fe6633f940529953184f474780"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "854db51dea723eb6ba60b4aeef6f53b4ac22a414e36426d76b52fe2b8618dfa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712f6a5e4e076a09c6746b5ef5a4252241cedb8c8cd60331dfecb4f1e3d6ea88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00cfd344d81129c633f38f86cd444c235b8cb93f7b1d02e3d779f3ff87d4517b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9ae2547c2a49f36c9d41eae14a9f934d537428b9bb508053cc1d607ddae5b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "7eddcb48f9678863fda87ce8bc0708f0748d2eb72ed3e1f088805da9b60cc996"
    sha256 cellar: :any_skip_relocation, monterey:       "a871ac5a0fc1408d8d0a1dd549d80fa3e91acd978b89cd7c0263eeb18930875a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5f36ddc88f8964b01678ce9d924c5eadcb416d4cfd5299f84a1541b57e11e6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end

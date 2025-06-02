class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.92.2.tar.gz"
  sha256 "40d0d189d7be6353936d698814677f69de8d470dcc857e9cca6bb36fc4523409"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "137dc89f39c21232fe61d1ff58f51ae0a576dd91a8ae961edefedfca821e343b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99fe0587de21a9507f3e923ad77da14df48f9a406655da397725dae0be9d5b7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29660815b252db5f0e8672bfeaa22e89ce6cd3b73701bb281bd76932e3f21e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c321a10f619c9d858de9d51e90782b93a8db9a3c400ca4c1796def8f2a5a7f53"
    sha256 cellar: :any_skip_relocation, ventura:       "779672d76614d9f4f4c465c9cc3eab716fa065197fbecbd25de3f3d5bd753dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d09ed94efbdaa2040cce78c4c7e48b8777f86492a158d75caac372215aa0ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ea9e01eae2753fe3b1ba5c5c1192c5aa87c40a34e5c28409794ed8f3f0ac01"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end

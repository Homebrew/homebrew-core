class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3a1779552e430824a92fdaa2c7d96e4bb4368a3499a5ea371d415455d96225d1"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9f50d3599dee71672346bc72cdcff97b1634012d0eb1d9e45de76b74114a94b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a49c5486365bee2956393d2517f8c56c960b6835e61499d409033b1131c6c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e82f42e02bdec29fd97fe8dc58289bc9df8edfe8f8f0f28b966252d51e32af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4555e0afd8a5661fba14361c7ab98a4178395429bdef5d1d4c95aac25a09aa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed70e6341011b40cc91c73217e3b4255e778df6f47394b855474df773042edc"
    sha256 cellar: :any_skip_relocation, ventura:       "5047dd750d1c4e2bb1c6f8a4fb41b870e45976c81713988b878d5fc71d9f5c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4980282007aba0f1fb5bfa1ad2da95790555b62f778584f8ae38a76d9de892f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0c2b0b85d312b495b4df02f3ed0d55f96df652b8d945c0913fd5e5ae6dc040"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end

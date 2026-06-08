class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "56950229cdcf52ca9014c10ab98b3050bf824656340eede8585ef33b501f70ac"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c22c05083f4dab2bc01d06f0d3d6f03e5c524a72b1b8ea7f27538b89d306ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae71c5e48dac0f11d66e2805fe03a360f6032c0b3a4105feaf698781f6e568dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a228733d40f0f8375ec9498c1b99bdb1885e9246ef9ab0d06d5752f3e4d9d3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "69f2ae0cb1380c725d565ca50f210f83fabd96eef26336bc319999bd5033a1bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b350ea2e3ad69b96f22f9d912da41486d8beabee39fe94c5b383af1bb824fe"
    sha256 cellar: :any,                 x86_64_linux:  "f792d6f559a6b94e3b4442fb5a6a2b009fab2c396afa4000e5b139ce6b6d7b50"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end

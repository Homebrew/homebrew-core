class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.7.tar.gz"
  sha256 "2a76233b9505b56412b6e0c94262f5e280ee994f52b274b91d2d3885f5167896"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9939142c9afbdf45d913167c183e5924e210c974a96f0514303e54b16250e69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14be1d65fb6c9a2ca089f95d2997748eb292085a18b2abee91722525eaabe452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9106aaae80f1dd972e111bbd214d2ae143727b69b3e4c9f2ef8146534d12fbad"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d7ec94d78cb849a577333123139e99109882573be987db24b45ea27d85fdeb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a920907c0b93e56441159d28beb97e38235211470f3fa4a1f2d2d2a4e1e56150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba723d8589e4ac397193ecca44b4bd24aa95a3ae54e4012e15416a79ba0ce288"
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

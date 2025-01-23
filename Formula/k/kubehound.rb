class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "e1858065aeb44d6dccb002bc909be9fd8b9b228ae004c4d74bfebe80fa8c13fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "888caf7860ec3a590e6a1f2191921bb4e6f3d5129dbe354d71d88bcc4c0ac429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b0196974c1d8c2970d701d4802fd598d6148c3c275951c1a4b6a900c1c5056"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a185b3e70a407d83f15c744cf580d2bab8eaad802f06f8c6d546f26fadc47fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "324248f63f536e09ac0fb11135b57781c927609a5ff8e4714aa909fce63d15b9"
    sha256 cellar: :any_skip_relocation, ventura:       "492e67b3de12c1eb452a8482b64a8bcf6eb3c136f3ad4b871827e4f4eba5fa33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d788fbf5f76adce0f0975b6f18cb8708dd6451981b7cbdc60565df6d4e792f"
  end

  depends_on "go" => [:build, :test]

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X github.com/DataDog/KubeHound/pkg/config.BuildVersion=v#{version}
      -X github.com/DataDog/KubeHound/pkg/config.BuildBranch=main
      -X github.com/DataDog/KubeHound/pkg/config.BuildOs=#{goos}
      -X github.com/DataDog/KubeHound/pkg/config.BuildArch=#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubehound/"

    generate_completions_from_executable(bin/"kubehound", "completion")
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}/kubehound version")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    error_message = "error starting the kubehound stack: Cannot connect to the Docker daemon"
    assert_match error_message, shell_output("#{bin}/kubehound backend up 2>&1", 1)
  end
end

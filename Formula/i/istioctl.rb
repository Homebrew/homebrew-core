class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.30.3.tar.gz"
  sha256 "97357e9c43645d2e2a640993df6a9a61c4f98485f95a1ea860daa6e893128112"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79bc2add4d388265f3040c757a7ff03e4b5a99f301f8538c2064d693c302213d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297d09def9712552d1f73c3e867dc65c79ff3c2086071497ba1befc300ee62a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4b7947d290bb9ae27d013b9f4474e3d3aec5b0aa1fc3e028cc02c68d976d372"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f660a58cd26f0981292361107d7ddebcce5407380bdcd0449f5acc9e4503ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eb928a0bb557714697433831e01c1c67c65dc7fc7793d9423d18562481450af"
    sha256 cellar: :any,                 x86_64_linux:  "5de8643675335af05c6b7b0f4bc1e9b5fa7c661ee2af906ce88c7adad5edaaad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", shell_parameter_format: :cobra)
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

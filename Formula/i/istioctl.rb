class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.32.0.tar.gz"
  sha256 "223c10f3460c3361214e9bc3a041b7f466bfba7847302675662f7890247afd34"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "301c69f649afadff2f82a4153f08b70554eeb0edca0accd58f968f08640cc318"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbbf763e45e68988545a62db72ac8472461881126ecbb8dbb1abc0b8eef929a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9c0f07c6c619a2beedddb4f4753908772ca79e231a90afd5dbf48f6ca0963ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a5dc6e379787f27dde7c9914261227a2f4140f5cdecae2acaae02143a177388"
    sha256 cellar: :any,                 x86_64_linux:      "0ae32dce3ec5c20858d9d9f19a4bc284777e814b1515179b323dd7ba9c52d43c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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

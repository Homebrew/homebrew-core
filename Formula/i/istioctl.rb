class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.31.4.tar.gz"
  sha256 "32f917c19d9510b33568979a49de05b4ac8e26ca4e14484450bcc007e2c4c575"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0d96e8c8499a8121c664d09869f31c0e51ceb0f9a342c3ae3bcb85dd81546f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de381ba4cb02bf4ec1544a744a618c192c7b97dcb09ab98ff693f32b9159ca96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6da5dcbd91859dbd9e160181f7bd28217154031da68c390fca350c6afb1b542"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2a8662bfbf96944115e0998796ff902e799452d70350dc35741db53aaabb366"
    sha256 cellar: :any,                 x86_64_linux:      "7127a5c899fd1c77dce09c08dd965b76afbd57bdc560307bc0be104c76ea0c88"
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.31.2.tar.gz"
  sha256 "48758d42a47fe41b1a3ed3cbfda9390397428d0ce234f53d812f53b55124fc69"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ec110cffd3e979aa1b2b32160e70e399eed86385d2ca740bfd16997064dd6e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f07b1be62f82f05047f6e9e054fd6fd92df38b99dc7cb2b5c24f8eaaed0b609e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81bc658b484dfa56cbdee3b454f1b382bed9eff8a4687adcc690c910756b97da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "acda0676a9750b84c50a121a5e74573a042e056b8108fec8656205c249773932"
    sha256 cellar: :any,                 x86_64_linux:      "670f7e94b56583b2c4872b4b32d88afd456dda9d4f40ae4b925035228d3a59f7"
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

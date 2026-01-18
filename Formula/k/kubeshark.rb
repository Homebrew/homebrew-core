class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubehq.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.11.7.tar.gz"
  sha256 "0944fd017777e936f6cb231213de574d05a8239402d761587743fa86bc2f30d6"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087dee63d8ec3ac17fc8fc9fb8684ca27553cef283afae37484cafdb1dd7dc9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb65c931d92ad280de1e8dbb2345e193a39bb9eda9cf0da943d092ff03a6b7d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ee2799699fa35cf8beb35fb2c3e500357841ecd90621f20bc7f0462b88b12d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa46747e8f128edabb93c4eab2bd44f9fd022d2d926a16b42f9f52fea3294db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dfe05db8d202f545f428376de80b573df62cda6c1e0a11ddc206e5e2816ea14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e6b7dfb4efa6e740bf4e982309708993cc0ebe14750cb84e5330a6f38d3ee6b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end

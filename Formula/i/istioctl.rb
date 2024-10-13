class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.23.2.tar.gz"
  sha256 "d4db1a44275f0f1a1a209960c9087e7006de5df7e41a04716283feacf333aa7b"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93fc940dae393c05deaa639c68c68d402e61a0bd05093c65584cb5e4dee5818a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4437e167625082c123550a01624dca004356ad966b5ecd477eda3d336584e723"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87ea5537d1416a86ad9f46e78655b256229ff35f265d630ee9776d9bdc0a0191"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0313773b0d99aef43009bd862ad1e8fbe1f0216201ff8b1c822b5328ad2e30c"
    sha256 cellar: :any_skip_relocation, ventura:       "fc85d32a8b71d6265b13814d23f6d050b5defdc760fe7d8b5c1fe56b508e600c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41fc0fb60580820b709a8307d0baca19bef0628040f40ef2a1f63adcf49589d3"
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

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.2.0.tar.gz"
  sha256 "dff92b1324ccb5e307779ef8f0bf640f1e0528323f7fd0f10c94220b3d18932e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5525f648192712c53aac5d5bd5ea833b0f179fdbdd6b83e475b30eb28f7f6bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5525f648192712c53aac5d5bd5ea833b0f179fdbdd6b83e475b30eb28f7f6bb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5525f648192712c53aac5d5bd5ea833b0f179fdbdd6b83e475b30eb28f7f6bb6"
    sha256 cellar: :any_skip_relocation, ventura:        "74525d819b45e43684216e2c07bbea88ec1373d7be34be7dd774c768c5a5c077"
    sha256 cellar: :any_skip_relocation, monterey:       "983ecc759cdc3810ead666b392c14922eb9452b426b8b516fd7450d3ac6cd926"
    sha256 cellar: :any_skip_relocation, big_sur:        "74525d819b45e43684216e2c07bbea88ec1373d7be34be7dd774c768c5a5c077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28899c8ab6c235480c525b40f86c209a95ada45652804175d50f14c324552f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

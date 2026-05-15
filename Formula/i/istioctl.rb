class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.29.2.tar.gz"
  sha256 "2d585ad87f4c4e3ac581adc36c3de87b2732ee775d34397e07b72f9d21ab2399"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f38d96bab8c7cacea2d22fe8b478b83fcc36c99b310208082ed5e5f04f8a20a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fa265db8a3283cb9dd0e8ac266fab1ef4c903a753408e74047cf56b7067bfa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a055ebedf835a847a3c0dc5a4c741fa094a5960811dcb28200e832ad2c503d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "59375744df0ce713d05f80fd4be6ef2881504454eb959fb4c6d757ba41cbaf83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46c7de76aa0c945e65e64b302cd742a0294d7bf9991cedc1c30cacd40d1671be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c197f144541186e071a1560ceb13efb915d9f4b8b835fa74eb29d450d9195cdc"
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

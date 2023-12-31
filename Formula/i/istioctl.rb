class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.20.1.tar.gz"
  sha256 "b76a337b037724e2972ec17ada8c5a056633e2099473a2af45eb6010dd6dc658"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44a6526b71ac3231407eca581d9ee28481e29467c16d62709db36b74a5c4cb3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f122f4000357fd731d5c45c6b32b7ac45b5e1afc119e2e200feeede503d4f96c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d55b3394ad0fd17030656e6a66830dd4304e186c05a8803c1eb900d5f447b82"
    sha256 cellar: :any_skip_relocation, sonoma:         "23e09765cbeca3f0e2f4f11844b45e68d05e8bc897dfc89f95384fcbea8b6b1c"
    sha256 cellar: :any_skip_relocation, ventura:        "f7775ad9761a12c2acde8cf9f38b7bed6e95ffdd0b6a12e832231535e845a278"
    sha256 cellar: :any_skip_relocation, monterey:       "cde2882db8e94bdec74bb74138216ef7961db986578ddb7028a75b93eed6b1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4361e8a881e141d83098b7af10be9a8bd7f3ceade25ee9e3232f0f0ab659603"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

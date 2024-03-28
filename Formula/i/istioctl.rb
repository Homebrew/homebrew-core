class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.21.0.tar.gz"
  sha256 "2fa4cd67657feb9924d3c04137304d19de6b32c371bb4cbab18553d33dd9c95e"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "765846ed8ad931cf1c3d85c8c1ced1f8df72ad71c3a89576ef42cb19ebc05029"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1676c43076f18878855df43bb0e1b62aa7b3798178aae8fb42ec163e9556f177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff7a45882ad7267afca59239a98212565291e65f889858bf1b09a8ccd2060e02"
    sha256 cellar: :any_skip_relocation, sonoma:         "24d79544f991c790454fdd25e49572e6ccfc3f8f7d27f1eef07ce2aab6678fb9"
    sha256 cellar: :any_skip_relocation, ventura:        "205c04f06392e8f7d28385837e6368d26ef9854924610dccf47d46bd0d93efb8"
    sha256 cellar: :any_skip_relocation, monterey:       "a3c419744145962f62bf0d0587699e3e8368b1038f28222090339d3da122f9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b55ae5ab1d2adf0956d2e0bea00b5f891bb7bd7d796ebe6a6e62423b136d207f"
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
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

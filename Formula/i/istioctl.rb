class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.26.2.tar.gz"
  sha256 "fb3b3569165e8b1cf01c676b7ce9a903abf730446df7e2753f436072aefbfd5e"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a0b2e6360b6b88e5d652c875893a563d8cc5fb05d4a298761e49b991f238df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7304c24e4392959f2733a299a3920f7efe4812b78d5d21967c24fadbbdff073e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a053c362212f0b5e2788a99c8416d2b71e285f7f4a036fe63cfced72fa482c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a65e9e7b14e6564c823d6a6c331643815a54f6bb13dfeb718f202780ae76326"
    sha256 cellar: :any_skip_relocation, ventura:       "70e997fb602b48f750af1c78b3671fc1daed07ddce7d92cfcad4d3859c04d7a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "980026a1fcffd71f9d06d7c58d7ba1d48e32607dd29fbf40312797bdff56948e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e50b86719fcf41e4e2eed6ece37c0d1c7ed137cb8c38088db73a2d3b13f5ff"
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.25.1.tar.gz"
  sha256 "a94d4a1802f60f47f93aaa15903b53e730fd63db41147c556a6e41fd4fe4a14f"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08ee98b092691b629ca0d70ebefbba1358077eb3070abb3a8c81888e07d9f848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "871d358c4aeca3c8dd7b2890f21816d07b21ec0f3cc6e6bedceb91c7ed86b8fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80118e01ed61e7006c471636b61588f5db404d32dcbe9791709d193060f6f8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "68470c5b1b2603e722ee3b9080dbe465b6a744e872c0e52faf9c4d5e4e71c677"
    sha256 cellar: :any_skip_relocation, ventura:       "e3074d0393396f3820c7785805baaac63385b35e3eb8dc5b888df0ea57b277b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a043c9f4dba41c48ad756918d9c0f894e524dd6f65eb54c8fb05bafd6688f0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0432633556d010ec600771f2190809da789bd8179ad45e5f8bf14be656d42408"
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

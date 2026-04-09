class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.29.1.tar.gz"
  sha256 "b99745fb1b32438807a66b3114ef914529ed21d7ac36f479c1a25ba703db728c"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fed25d036aa0c12385da48f2eef9f2b2e455f1f5a9d1932c3680f5af231f99ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e7dd25658143461b39d0a2fbf5854e2434fb1a01f80ad46892d0c3babbba295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd15631cc61ce6c12e4bd6162341ffdd8f19bca15c3a587c4c4c952f5f5f3c80"
    sha256 cellar: :any_skip_relocation, sonoma:        "73360cec01a472bd3ee27f436b727cf2255d9c8c4a3a9986a2b672b7c48719e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98016f2f261e1a5b06904ff0e86db36d1404f043e386a08c0b1c2f269bfd0621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d4140e59a831cc315828a74bba413886a7b3fd09575b279199ded3d87206fb"
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

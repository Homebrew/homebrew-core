class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.28.0.tar.gz"
  sha256 "57f6bb99f4b12fbf6da33f3755cd37a7bfa10092e08cf420b245b2d758666f12"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2d40d3d8bec4aa310fd5d03d994af49665c4bb2f6d0a1e91ab49f5945992b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c71e08bcae9144aa464df4deedfc2d1da9bed174223678ca5a4bf228e1bd5e21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a498d452d37195814644260ebd93d6d132074a25adf695368d8be7817c1d12ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0267a29428d37dd9c5ef1b1088020bfd5ef447f938cbe83b297a8a87718fb49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d6e19e03cb79efa83ba635778139f6d084f7b15495388b82ef0ddd47283cfaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22e4970403d3d1546043a36901b607343a34d425bf9dfff51695450625a37fd"
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.27.1.tar.gz"
  sha256 "8ecc5f82c1b439c6c191d4e3e70bb2ba3e36a8eedd127445a2e55f0ae4073257"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d682a859bc2e8d185b97d27c598174b6760352ff2fb27404cbe82a6a87f9aa4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ad835c5a3ec7164fa85523cf290b42a404df42fdf250333a140f96154eb95c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890558fac42a5c666e4a3f418e0ff327aff87e2a620dce2001f252b9f9929443"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b068571624343db5b5296f1e4d5e2face0daefffb04f2fcb82b80b35e0ec03b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea34747765f09ea3c5bdf4afb875c2e1eeb8cd7666b48dbdaa9d5f69589f900d"
    sha256 cellar: :any_skip_relocation, ventura:       "91ee22965059d3af7d5a87941e322cee2458a71da82c9879186778059b0bfef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436960fba3fdaccc4d9b25f1e2ba1104aac8cd53f2a8fe79c64eadb3f93b8048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197ad04665fe2a10d9c8703819cd32f2e19a704cfd142b0067a1801370a2582d"
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

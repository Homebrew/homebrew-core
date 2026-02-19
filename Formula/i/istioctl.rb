class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.29.0.tar.gz"
  sha256 "85cbcf40966ab6f3bdd2b59462ca058ab62fe44b947eaefc33ef494de8988c04"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb7bcf1e091fb3e610b4da78cc9cd9c433d781bb7ef29b8c36806b091b82034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27e75cf146d5eb0de465831ae4468acdbafdc56d48230d195836c514df05ac5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981178c7524af2dfafd20bedfc3efb3feacc1a899864c6863c3c922a11a46a08"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0aa249b6da43cedf1c355a7e76f97c8b96ce71dd090ec5004dcc590419dc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a274d239c90dfb2b514c12d86021bf5f6d0699970d057fe4fc1967e1975df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720e1ef4394d3502eb6666ad86e67d3650cca85be6faafd482d85ca17ca61200"
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

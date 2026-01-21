class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.28.3.tar.gz"
  sha256 "f545dfef2297c6c643fa98b217435472106822550d9b08e66fe0831b6c740291"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44ef04cb21f2fe2b8bb56852b89e87a12aeac8f4e9596183438933bbbf3eab69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9fc77e358be6ef1eb30135e5b25bf2faaf0d50bf655cc823e91389e61acda45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7369dc9ec787554c50b366d7ad4170ea73ac8616100b676feab9e97eca88afb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe09ccf410e189596212bb1816f02e8a7301075e709e4535ab61adf801f6bb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "280a2fa06d9d7bbd0c697af540364a9823f17391b5bf403f6a8a5458bde243dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa20b98b689821a541ab677bc216551434fac933dfecf48602222eab1ded9cb9"
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.19.3.tar.gz"
  sha256 "458b6f49f70feaa67fcb7328dbb23d92d74c8fbd272c6c6f82c9a1c74375972e"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60053b9d910480d49d2886af36a9deadc3f5ded226535968eb7a032f2936f513"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5c40c286ea0ab15aae0dd91f9552d6d891c2eee9351dada1b02bfd3fc7cb52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6effac04e3900f93b3d5ca4ae57cd6bb778f85d0c5afaad84640843516d3736f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac0ac152c9807577af2466ea2a7445baa24462896e9c21ccda0ab5ba2c35875e"
    sha256 cellar: :any_skip_relocation, ventura:        "02b2179466424a5c5e4191bd04e20d3ca4196bb89e162b38993863ae40a4dc0c"
    sha256 cellar: :any_skip_relocation, monterey:       "e86ebb4ccff8220c94bf684c390a6ca3c4bfde090c857027db53d0ef2db916bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e196d6111da1ca6a35a4e385048ea30b16a84443fc1361bb6d1724feaf6e31a"
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

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.22.1.tar.gz"
  sha256 "053e121a56aac7a75fbbfcab3332efe1b1577385b7b2e17f94d857f6bacbee29"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52673e8ae17915192f49414b620d5c6ed450112aaa9b05f57d0a1b637476b154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f68e47a91361af95437df6528986443b6a0059fafc097851ae08401b0af7755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a44c890311699ca3457e01bccebfff2afab51643a18aeb5b081925ad63b017e"
    sha256 cellar: :any_skip_relocation, sonoma:         "193685934f99c98393bbb65d9aef3f1c9463b94398be08cd5c2dd0c73598e812"
    sha256 cellar: :any_skip_relocation, ventura:        "95884c2c14df448f175dafbecf08bebfdc8945bf8ab6596077cbe8638a6a4f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ca5ee90f8d22386678c7fe6214a80d45233d360179d530ab6614a85e91a146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e395df84d059c24218e2faa3c8d030df75953150e35e00847f41be55fb4fdcc0"
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

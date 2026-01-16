class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.28.2.tar.gz"
  sha256 "ee4b5d1ce045c98e09e97bce2e48c2d1ae262ae02db8829b5b1f4b3e546b0874"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed2988079b8b4c5c4d7248a48a23174128fceae72d0a88c9609f2466d5061add"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f07301b24c65d2c5dc7cb83c698d04a7ed30f1fb2be9b9d5f54d5d4af77bec9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ff84a336e13de18b00cfcb7b5ba1d1b573a9386b23def847374e12cc80e3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39567f2dc0f6199515a871fe9ae3ae74bc13f932a5dce7003287f3eaeb8b489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f14438da1a5666a3761c9889fddf0da94e7442b896332d7ba5b3f2fc579cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e94f6555b51fa9021d88d396f4ec657d87b5c6dce96fb855ec6845a2d066d91"
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

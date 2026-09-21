class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.31.0.tar.gz"
  sha256 "92c1b606ee9c7ddd644dd523978e5d22fb3d62775dc60cd5cdb613540100b1da"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1b9bca35e5de30e8b038956716e2f986ca0bb3b2a03ac14d97d99f99bc6d2af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dec8204ae67bd9bc302779ee27d17dbad789707377f9c674ff62a0d608f04df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4fc4941b5a953094f8072189abec56539f4d912c302dcd118a4692a40e80e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f8f4235edede9af825c01258effca9c3c3bb9abd559723fc7f92016d8ea69e97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9442c2e8dbf3155d8946513b3fe0f34649707e1ba80a82ec87ea3d3d07c9f39"
    sha256 cellar: :any,                 x86_64_linux:      "2d1acef05250a2df7ae539e9d017f7793ff1690489b034a339cbf70bcd66234d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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

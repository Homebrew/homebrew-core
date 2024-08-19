class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.23.0.tar.gz"
  sha256 "e29fd51c035d489b0e8b74d34f0a33014f1e16ac98077d866d09fe307457213b"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597550de23075b6c6d5bd761463901fb2a0082cbad036aa6d4bda1b9438a4bb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1482b0bbedef2b5ab3b2b7e7dc489de56933ff0d02da57ecd2b4ee019c13b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b20320f2c5de3aa1573fab236a79aaa451314b92e7d67659fe361f24401db1"
    sha256 cellar: :any_skip_relocation, sonoma:         "90afdcfcbdb14799e60058649ebaebb94fea8cf9caf09aa198570e0b7cf873ad"
    sha256 cellar: :any_skip_relocation, ventura:        "07e4438c6a7fe04349eb90f3f3c9411f473f2d643bf8f52c1991dfe6f6448f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "a908c065ea37a577690c6c91f57456b9a82764b0f22b890acfa28796aa398849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab719dda903558daeb5d48eb18a3b25069532f53144edf4a37b3853aadbe0ca"
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

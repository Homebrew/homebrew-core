class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.9.tar.gz"
  sha256 "548c8364c5ef81123fd2fdbb6e6d0884d85c782d612ed557b8e42ca28bda6f8a"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "196b6810a3d97cb483d2179c66ff95b4d0ff44f3dbae10738f899b8c2eb216a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "246fd7168ea4c27f04b1a95d56f40f12d2e97311814b4273e117f53c578a5186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "775909332bf73ad0077632b02c6dd4b8583ab57b089caa3dbd215823ce630f01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12f6a5521c3d68ee9698391e7d8224ce75b7e994d2c102c81a880ac1eb0db448"
    sha256 cellar: :any,                 x86_64_linux:      "29be82665c19c6dc72d53350a1f1108ada4945804c384da0f2c97de2c15aa589"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    goos = Utils.safe_popen_read("#{formula_opt_bin("go")}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{formula_opt_bin("go")}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=#{tap.user}
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end

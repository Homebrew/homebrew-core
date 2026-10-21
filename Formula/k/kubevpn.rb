class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.10.tar.gz"
  sha256 "0acbedcafe51572c42daad67c7d8af5ee57ae566a80fdc6d2c9e6fe5fba3556d"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02c35ac803a4626024f1355777e55ac9fee06767a2ef5d091d974dcb6de8e33d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23646fe94690b5fbed5615c6f1be04e9b823fd1e92f7e73792892ce1d3be5af4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8708e483a85c6d6573948035de9c234280fc195a7b65a9dc0052a829ce38087c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56dd9b75328f76e50952eda64afcdd7586e666341080f0f66e62b67230d81223"
    sha256 cellar: :any,                 x86_64_linux:      "1a589aa6e9f7f179cb73085c79952e708c1ec0faa66e7e09f640d51d5dd20585"
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

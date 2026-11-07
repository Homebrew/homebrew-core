class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "fc2e828e8425170908dd726e234d66033bfe45c8eae6e773a821d31d53ad0d6f"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "163b80dae6c4e5f0c5e15558ec93a97d2e8aa4fa856cba96d56a70084c0e0997"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d904a612419993868c3117a289431fe29e78f68e7afff49e473abe5dda62d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebb9afcab1fa70952dfc7913e92a20bcb6e5a0c0cd234f81573cf26afe8eab40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eae96560af558039f89799c06e19fb397ba0e23990349da772ad6d0771db34c6"
    sha256 cellar: :any,                 x86_64_linux:      "18098aad4e428f4513033afd083b033b524c13e86b9c3507f079e7da9e2dc7e3"
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

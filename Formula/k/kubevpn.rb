class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "14dcfcc16f363bb34af9d5c11b6bf9e181c4a4b481604eac6932c59515dd6f7c"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7caa6f7d4c0a052b4f64645cf796a15126465ecdea8fb63eed706c2a037a20cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be2c3cd30ed1b4fe31761ccfbf95927ef901b55ff4d15cdaba0e25bee4534645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "739ed0688ad92ddb3f0fddbeedc2ae8803513a6a73bb5a61a0534ccc37db686f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c9200b09ae7b14119be6336cee9af153c51642ae33fc90422ac7a2da1d236d0"
    sha256 cellar: :any,                 x86_64_linux:      "dd261d1fcf31fcc8070e64f2db691b34182fd01445039bd5ef73d51d2c843618"
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

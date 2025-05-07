class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.5.tar.gz"
  sha256 "80217df1a8957ae2b47c810e3948893398e6d5b01ad97354e6172ed8c41a6f17"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681928136c5578748a0136dc6a3c3fcab02bc37f90229eafafa0505368beac7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67d8fe214908d2b66bd6076beda337b47e570889df83d8a680f77370eecffe9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b844ad36fbda12fb52c3d55341c9a4db86bf919c1985f7e7c913fa3c68f5165"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8216e6931a42f18af2a59861a0883b5b4705f7aae083825ba5ddb4ac9b526f0"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b5a7f5823faf697fe92450a0641663306d5f147446a8d8945660347fe46326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a723a85869b6881ecf804fc75f7ba8c341ff57548ca5778addd1c76ec368a049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bed0f2ae7aa6f3e5ab343d133eb6a0a6b46f51ceaaef262cf669bfff2b590fc"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=ghcr.io/kubenetworks/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end

class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.9.tar.gz"
  sha256 "96a4d3f1207ca3c9fa49960da3f41fecc7b9f5d569857039e61ab6d7940dfe3f"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bc66e4435a36301716d81ca02a06d4839ee2f40030008cb9927efb7949a772c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5c4a63bc134577ceea5614122af23e98097146ebba3c5d859ea3db0e28f608d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d45b438783f891de221645caeb0495efecdeb44539355a13b38467db712e3d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3223f84e66f177bf6ee43da39df626588a188c897df5433afb8898cd653908ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20c916de533395c93a57e72daedae1deda14383ebed14e79011cc338c34cb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5904304860f172cbb5ebbe9e68b3dc6ccc164cf44dfe0bb718bf30aab05dfdf6"
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

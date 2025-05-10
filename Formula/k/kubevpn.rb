class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.8.tar.gz"
  sha256 "02e24ad6c1ec1b41aab74d92297f60f4ddb5f217c1b7cbdef5153cf8536042f4"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803b8d578aa31c678f9bbc7c265d0efa3306241ff0a4df26103562d20b62f2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ebf8d2038d5c7540b4848dbeaa685f52351bf39d82c2639d9616abf64c7709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90cac45ab4cc0d770e387247ce2dcf339b3d4f3cce11a776dd563548f9d71328"
    sha256 cellar: :any_skip_relocation, sonoma:        "113bfb129746dc5915972dc222764eaeb653248770544b803ee16bc01ecc7183"
    sha256 cellar: :any_skip_relocation, ventura:       "0fcbd6a96828290e795535d2ab365b6a674241f64759bfec895157a20c7c68a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed4bdcdab3533b4ae2dec135dbcb8330dc84b1938a48e6c5226d9e69fb8b88b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e839f9d886fead4ea60d5323f0e6697352e165d77ccc348789cedba1d0408351"
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

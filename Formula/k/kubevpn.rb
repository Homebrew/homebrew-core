class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "1f9e6a52f111024a804cbf42cff495ff9b5f007bac3794d12ef0d96b5602ce73"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "509c0578e264675fdb22febbcf92b4a7c32c0ec44eb5ae2c1478484510302f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bf70935592770751c611207eb78ada15e2670af613b0666e4896136ec3c03b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e14ef24d0fd1d3bfe9f126bff1cf29fb132b6cd3857bcf55fb6e7fbce535f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "914113b6012b5a0d6772a3a301e8aa9d465625c0358f4f4ecb7505c513ed54d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6032a520dcd9b137078c3e980fe994ce44910c6c9c7c227d8c6369a8f01a9cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4155bfe10ec35fdb8ea1e1290fec8bb3c51b5dc67fa58973187f7f3e424741"
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

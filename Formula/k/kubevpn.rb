class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "2ebd97ff789de7f36ade5f94cf19ce279f69c878f75023b3140e3a3f7c2bb2c5"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8526da1fe3a1f381358ab9ea6d7b3c787ef2fd1e0d5d3175aebf7ad6b8a25e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3abb4b7c8a299eda685a614afba9d3404b97dd2b0b2a2be0b4eb17c2911c9382"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "223df4c21fa1fce82f4d6b61b5992629e5844f95aa61d86d088c8abba503ff33"
    sha256 cellar: :any_skip_relocation, sonoma:        "4acb91f660f022b7f33adfe5ad1694308b3a45d51a929caa05454b771d362184"
    sha256 cellar: :any_skip_relocation, ventura:       "1d60f5d32de3eda4cbb21da525fd78e85871fff91569b544a83c4aeda7e382bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a22cf4a29361a97c00fa568e93a253b2c8de0066b789d2affac1877ad8853609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf014ae3ba2a8eac5d7f1dceeda87f0a81c1d4c8a0eb2814d717287dca1de176"
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

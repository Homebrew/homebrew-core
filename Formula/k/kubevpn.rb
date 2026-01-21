class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.11.tar.gz"
  sha256 "3de09bf70dba2ed7a63ff58deb3df5219fd715a8177f1d9c9ed06df40f894e9a"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5719b248b63e504297d49cf074f3f9fe20416df03341bda16d9a4ce9f517ecbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85cd10a54fe996efd857c88148c7d28609f2ad99342b4a7310561fd0adc4070e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8290663aa7dc46af8d8a533d018a8001d36d084bbeef0c2021d8b6b0d2633989"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad32c50e40a27eb9ecadbb4e9b97e58cc48803f3cefa8456a05d4d9fb5553bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6aedeeaf2140fc0fd54d1bafb0dd8d86dac4011eabda58edf9a30e2f24e8649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ea2cdd01cb84c401d921db0c0f3ac5355cf9ddd29f093ad0a0a5a6399cad5b"
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

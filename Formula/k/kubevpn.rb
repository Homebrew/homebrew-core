class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "d59d09e6fdc69832ecf8efe0098d522bb0192b7b2382db1d4c94447ac0297718"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910a77c1903ce50ac54ee0f8296a6fca9a3a2c8e240cc6ae82fbff690da478cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bbd5fff591516bdf22650175e2cf676a39ff673bd7175f2ed29742a5c49abf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58871846608830e98414be248d0d7ebd0bce983559c803688eb31d128524b0b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "66e710dc1065ad18230d21d954532fa42b62b2e7d82b91ff5b5c561e4238ca25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f46fd4f57bd456d420183ee9ca13d3c3f2ad540868d986a3d3898de1473ecae5"
    sha256 cellar: :any,                 x86_64_linux:  "42b82a32f5228c198621314309ca72f3e003f6c64e0c20827a469c970cc0de1a"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
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

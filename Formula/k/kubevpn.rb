class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "2a7faf6d8fc2def6bd6e54bd1c7e6ed2a78c7f499febec2557931cd70305a946"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "021545258d4ff720ca71ed35543fe0839ebe94d0f7059e2bf8f81ccf44c89408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82e615a943005bddbfcbbac1a0b23cbf648ccc18e7d5374570852be05a3056d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f342856e1b2703ce7b1249d79f38162494f2a7a999c1bb23d5b818b4c30e852"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a2d02692b2b0ff8c3296090f38f4dbb5a969b31a180fb2a5d3828ec6c9016a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14767619612dd9d8d88dadfdae084c77a04522afd993637d3c9f88d3a5baae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab7329ae1d262b89b0ae86f0fad6fe8ad8f3d42b87d7ab7209f93cae42658bf"
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

class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.5.tar.gz"
  sha256 "fd3a029506bfaa4c09ce56865b88ca314746345f2b5430081783d2ea19ca6a74"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c2092d849682e6e58c6317253403c850049268a49374293517f4c77195b3e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e49a9e48ec1c59e5c4c1a2976bc4ac925a0c9da1435b3aadb10f51251cb0294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f045863a529d95e999969b04ac97b5de3d7e85df6c23cd1fa5b0023ad35118"
    sha256 cellar: :any_skip_relocation, sonoma:        "986a8381537867404963473c95c3132e724ca576fc682f94cb61b51c99b239d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75212610331b8881c158832a8636b14b6452b59076e2944b1c7c63a75a9c2108"
    sha256 cellar: :any,                 x86_64_linux:  "c7ff12c4f11af45f06c16598e3b7631697c7952c56970bece85238abe7afaf6f"
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

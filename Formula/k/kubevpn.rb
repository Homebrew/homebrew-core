class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.13.tar.gz"
  sha256 "10746959d2e2576072f25e8c45a4614fd88c0f8124dfb93c23e35a4ef6c10c2b"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a2ac3b80ac07c04526e958410a38407cd4b80dd7f94fcdd242d0c6416869a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd78e482a4a25b9d287bfb3098f88cb30dceb7891cb2978ad4369d8c7a8befb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a03b268a50320aa4c922c1301d2f1df72fbe37ec5e1f7896fa64833ef920132"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a77bfc7cdfe78241d78a282ce5a968b90c5a68e44e39268ba85e84bcb98a4c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37ddbe98c7c12f0a2f5a8f3bf4c78864eb1540b8e583152c43c46db45f2c5140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7e87aefca56710f8187b42657b79700142df6f4a297d456b99d8ad81cd89b4"
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

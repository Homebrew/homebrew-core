class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.2.20.tar.gz"
  sha256 "866d51f98936f99a26ad32cebc959d1668d495610924b52941d792ef1f32d5d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b3890b60cbc698d83ac1cd6ca4b3160e2e0bde9bf197ba62f413768d1672150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b7952e41beaf582e79cd05f36fde26a2f3c92d526cb024b9752d873594ab82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c043c0fcc52d2d20dcf90b28bde621561bba1ad496b0cdb580b145c20da24831"
    sha256 cellar: :any_skip_relocation, sonoma:        "d85d6c4dfe68f8adff717d9c3a99d57e6e242b5ffc9bbbfa007dc8c7683d5da6"
    sha256 cellar: :any_skip_relocation, ventura:       "01746f1e3ec0bafe4af56bb86dcd67e0da3cd211850d64f30a4284017104a6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a4531e5eeb3ff708be47b44158c90f128661d02f012407c751a47388d09f3e9"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    tags = "noassets"
    project = "github.com/wencaiwulue/kubevpn/v2"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/config.Image=docker.io/naison/kubevpn:v#{version}
      -X #{project}/pkg/config.Version=v#{version}
      -X #{project}/pkg/config.GitCommit=brew
      -X #{project}/cmd/kubevpn/cmds.BuildTime=#{time.iso8601}
      -X #{project}/cmd/kubevpn/cmds.Branch=master
      -X #{project}/cmd/kubevpn/cmds.OsArch=#{goos}/#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_predicate testpath/".kubevpn/config.yaml", :exist?
    assert_predicate testpath/".kubevpn/daemon", :exist?
  end
end

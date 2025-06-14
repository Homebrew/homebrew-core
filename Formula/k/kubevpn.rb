class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.18.tar.gz"
  sha256 "55c2c1f2ca8a36d35671b8253db3abf6060fe7c29e085107ebcc5ac5e9d6ed73"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfb37ea67951c33234a4df2f100c6999a63a802206862e6558ee6e113802fdfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f44a2e0f966173ccf3fa4397769c4eb69ca1ae5b391005edf7f191bec78e235"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03507ff2075ce02e5893d6ce15712e4609d246ed233c8de2827faa27255b4ceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b56eaeeb76ef7a7b4e8a630b920fbe533117be0a710ad54095c6d8325c92eeee"
    sha256 cellar: :any_skip_relocation, ventura:       "8a2141e39817265ef34922d68366399c17d8c37854971500a1c47fd69df62024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d51c8247b97453fbcfb281ea8e965003403bae8e4400f0db586141069b828d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2451ba147d6e3b124e24957abc56a28682d64ce72bdee99743619854ab411d8b"
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

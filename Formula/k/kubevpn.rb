class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.3.11.tar.gz"
  sha256 "917686df8c28eeb73146a7e52d78340fcffc73778144488c0d56b4edead10007"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "164f1299d59529fdadd42a3d99ac44aa3223542aef7b0fcb3aade13e01d6edd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9262a6cc117de0f26f6fd3437b86d3f4b90a2355b3ccf344c57e739dc99b9c22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8df4614c1c3006a013c4c7b2792970f023fa799e1b98c3a8042ce71226a0a37b"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e9a6fb2556a7167705135594321339351d38c821179fa98c5a54424dbb6f89"
    sha256 cellar: :any_skip_relocation, ventura:       "bc6df2f9355c2af5ca0947ebb9363fd433edbe9a25fd80fb8b485a7b294820c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e6a60f476faa5472e671e4ad92306f1d6263455d6ec274e8f7b27206191aba"
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

class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.2.17.tar.gz"
  sha256 "508b0a16547884ac8265537cb752c59339458066bbea6e1601485adef396c7f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9649206e0c20a000f03d944f35cd840d24e21c3263bbc54f07fbf0cd685dd9f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dcedf62b98d92c5014a0421875257c13ea77500dd5e8a9712e587787dc40f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25740d3d70ec48c317fff30773678dae77f05b12578e6cc71855a91d8de1e681"
    sha256 cellar: :any_skip_relocation, sonoma:         "f22a0bfe2a9df75f9ccb63247fe01259e4bddfd9473a69a7010b1fb7e41940fa"
    sha256 cellar: :any_skip_relocation, ventura:        "53e39aeb204c2610937d21f4f948707391399778d90f6e0103d822c8072e2f90"
    sha256 cellar: :any_skip_relocation, monterey:       "1288f98386495dca71b702e7a3faab6b7a43c195093f6e4779dff63d0a777b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73cf09796614b0fd584effd8428b7dfd3ac3c916e53b79b7d504304aa21c155e"
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

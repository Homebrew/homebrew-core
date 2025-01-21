class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "23893691e9e34aab86b2cd047e68a69eb414e7e37c3d7826fed41124afecc4b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d383d8689b408bee818b4ef6385315972636fccca72d73cee392701a1808cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d83193caf4f2b53ca40d930bdf864eac149e2ba7f1df51fbd130a8defd5b781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a77ab2a88212076f88a938ffceef53aa6fb3b3c53ccde29939fa985e624a84"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58b183872dfd22205b79cb31139f5d274cdba0b5efd0ca9baad97c16f5b00eb"
    sha256 cellar: :any_skip_relocation, ventura:       "3e229aad92c53793b006a51554caeb1ebc773573130b5f3d31a19a0741ad37a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d200dbc5d56ea288db4d401a5bbaf9eea8875456b3f4b531dd44972c9b763cd0"
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

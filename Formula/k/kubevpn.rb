class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "e734f22be1b18f379916059300a448a64ab84f8b9fea896750ef9cc3bd002315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c756572ee994a2525534eb85b959b72b1d5747e76e1f901deb6266e06d22179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "409d2c204f7d84be4cda23aa1b124600b4d920e3dc1fdfa061c83cfec68da3ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0535d9184514d7eabc5708a63840618f53ea4f8b78f80e82331aaea056cb2409"
    sha256 cellar: :any_skip_relocation, sonoma:        "38203c2fbaf6076c7759b153647815c9b067d158d2655bf2a19c7928a4017278"
    sha256 cellar: :any_skip_relocation, ventura:       "2bd82c5b0263c298cc54bcbb9d0d24b8efeb4dae8dd51dabca49a9aae52e2cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd78154e25c48213312ecf8c19944b58117e0466643009a8a1306bfcb6f5fa8"
  end

  depends_on "go" => :build

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    tags = "noassets"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end

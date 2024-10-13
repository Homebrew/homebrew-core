class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.cn"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.2.19.tar.gz"
  sha256 "4a37db518c9cb79b824addc8852f6a054394c4ca01cea6b4c22722704800bfae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14954715c2fd6de5ac766b98c5fb2ebe5576ce39cef83fa97c4b5b14089726e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4de07debb963882270eccc24b3b831345dde1cdf24e70b3fa2ecf44a470099e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ba8d244146a32242c06b2a7383e4cb61478e0a0fba7e84eb93da03c879083e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "caabebc5bab3053f79a16f8735e822962dc7028ce0146fd2b25b7db3cafff51d"
    sha256 cellar: :any_skip_relocation, ventura:       "a515d1e2b0754826e346b3e405010bb9a0f54551a246a8caf6e6a8bb13e5261f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405c3e55c0b7670cc169c6ab01af1ab105fe661e1e12e0eef5f1dd373f0586f2"
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

class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.10.tar.gz"
  sha256 "ad67f67fc8611ccbf217d836f06aa90d36ccb4d0cb9d2b05b4033607cf9069ef"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1994b5fb35a180c419b61b2b23aa20304130a23124630ff49a57181de293f46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700c847cb7e019a8d8155907b76337ce98c517c732bebdfe70ba4a9c6dcaf6e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810731db180e6f19a5d94afafd62f57f86ac2613e54d55395c351546e7ca7bac"
    sha256 cellar: :any_skip_relocation, sonoma:        "890734bf0c142a978da058c990500a226534edb8866c3de7ecfd1e4530511d64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f48eeaef1426dd1fcad16d8be13295458ae390ade34c224eb664effef860fa5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5a1b163225410468af6078a3da8bc387d8f7b0d37c5a168bf5c3ccbfb96e83"
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

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end

class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.13.tar.gz"
  sha256 "8a7edf3d21d0b756ed277fc19153f4eab450aba0da1b13633ab2d57570d1559c"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9edb8f72838d6675217419a33251cab0a6eafdd27739ed324cb35b7fede4ecfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf1b577e4082c093abed38b8e4d447a0fb213d02355b4ba954a7ea12d8cea2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d66f7c9dda0d1c0d2cc836ec241f07226abebc470a26468b0aa45dbe8b49ff83"
    sha256 cellar: :any_skip_relocation, sonoma:        "3649539f6b41f6e49698c4b478f0395648ae8d41ce864e9d51720a2b185efcc2"
    sha256 cellar: :any_skip_relocation, ventura:       "c30dd15639cb8ee28c73d1e4cff6e8df965469c5ec1807fff7a0c9f8f1f0edf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b94d14628f5eb069a85d055a0fa4eeca7dee1afa54463de5ec10190878ecbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a723ee27de7287444f77a4d62d61e18f873b543fde7d13d622a3af67ac9b8381"
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

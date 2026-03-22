class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.14.tar.gz"
  sha256 "96f53c0ade184bfa1e7404392200d6a238c80e4a7533b460f90db1e71578996d"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efbc64d5092ae17d34af6d2bcafca3804ac9a304d36fbe8d01c4bf3cfbfee2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08dfa8afdcb2e0c89ddd5ff732192b575dde53d9a9737f3ad931be076b1eecf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "064a193532305e4534f390e91d48ca4c9a24d1a47f724aede6e71f17e27de538"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c7122a7ba1844a0ca0fb49dd9d130b51ba49ddccb8d362f4857f60709f20092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71d8774faf7f680f5d2e07df54fd8182619a0c4f6362abb5ad80f9ea1d41c297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d2a4fdc67c446ffbcaf67d7b62fa05ac69d2e3d5fccde47586d602800e4f6d"
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

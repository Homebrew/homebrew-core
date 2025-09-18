class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.7.tar.gz"
  sha256 "e3ba565f4e5411ff52b2b68929eddbcca3e91a180bd4c3491c3d9023e68e064d"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6c82409a45d81b66e3fa87aeaf90522b9ebad5c493e7049b0b29eb82daf66d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72931f97f1f5bdce3e8df74e98013e9e05ca727f3b9676dc28ee07ee816e149a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc7589b468b9d7ae04f172a6c169cf797c1fcd952c5fd794914debc727576cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0590cb9e03ebc6e653382b429d4a8cf1de4ffb4edb65fc242fc8ac389150fa28"
    sha256 cellar: :any_skip_relocation, sonoma:        "7617b6edd35c4df2eaf484847172bbd882a21cf18ccce9db71c0e9559d1e2c64"
    sha256 cellar: :any_skip_relocation, ventura:       "ac199d4de224de747b3eb422e7f73b3093bd90b1ad468b4c1c4e90fce21b085b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ea8bb1dc16904099000ae0b61661b7b7ad037e190fe06b4aad62448f139452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725d4a75f0243c9ba35451c9ad03522365ece3f8332a2fb09ed6546c7cbf9fe8"
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

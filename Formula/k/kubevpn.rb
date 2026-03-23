class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.9.15.tar.gz"
  sha256 "e190f3a8015e95339a40295416c3789f0dc8995fc1b86fad026c0bc67b0b5bd1"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "381d603f0eddbd356e3e1562c47366d0a9a6fd0ef6338da9a488f23f1c0a8d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e420da72b880d3dabb877be6bf41f0e7852da7c6e4f4ef0af14710a5ae35fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52845c47a84f6bc6536dd2e2d300ca168e53e71ec177614f69727bd07907b7dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "451aede9ac863a3771bb426b806e3b23eba0d68f268453d189d7bfc4c592dfcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adbdde4bb5a826190a24fb8dd532d05ad494fb698292e9da849fc861fca753ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23effcc12c36ce6dc846d33c3caf586c74df42a58cf3f9b2e33b2edbdd20ed44"
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

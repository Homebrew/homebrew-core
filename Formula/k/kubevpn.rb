class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "c72b5fda9e789b35516425a49544eea117a24f136cd062ed305dd338703641c6"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "632e66bb02cf48e19a6c3c5d348d9bc6e75734feb073cfafe9e407cfac3d14c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24ac078265c0c504364723aba158afd313f37e450e2a466d57003e829e98039d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2cd37dfa0d716064f4c55b8fa8a08587aa287dca99ef7b16105c42eb607c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "216373d5e6a958dc01d41e7deb7a5451535def83bd74524119f334e678d5c4d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f6567a9ad2992610cf8fd60d0417205615c373a7f0b4feee751303f5d87dacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35366948521ae400ce287f96487b79bb73a7e07c2b9a3557c14f10d3ee809b5a"
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

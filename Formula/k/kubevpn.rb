class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "d8948aacb4769a4b29c95cc88f8ff6f7ab75d983688e1ea4e9e0b7215e4ada1b"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f1e896dc92005cda6e58ed1b41d48d1247c94e99cf3b16be3c08828c15f3da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23b9971bd0880131d383462c751795a9a2e179395e1c038814477c0887996c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b31c8203246946aa7326e6c975e031bf9af314efda0357ab5c95b8d35d71e077"
    sha256 cellar: :any_skip_relocation, sonoma:        "a94364ea971e795c0bb7248436ae02e00694fb1f6e3f6915d50d31d5548810a6"
    sha256 cellar: :any_skip_relocation, ventura:       "01ae059357c889d1d1f5edfda1739766bd6842d93a33da8815f50cd72dfef340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db2bdc20cbb3917b8793dd2f3a91ace14c81625f2760c79b0fb0fdca89d4276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3225211d264049c69c24396e3804bc7929f28fc2dfcaf0a302d730e4af4c3390"
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
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/kubevpn"

    generate_completions_from_executable(bin/"kubevpn", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/kubevpn version")
    assert_path_exists testpath/".kubevpn/config.yaml"
    assert_path_exists testpath/".kubevpn/daemon"
  end
end

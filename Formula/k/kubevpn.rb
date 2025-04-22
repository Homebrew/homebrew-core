class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "ac03d33df1a683c38cece0ab2e0e54e969be456b8505726a1bab9fe1fae7dc25"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a775dea7e8e90b794806ff250021f9067e4689260a2506e6f91a6aa46a6211c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96889f23df2de7d58ad795d4af484b8d27a74ef90426e75e67a8420d106d52c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef60e4f7102140d644415ee5492183822d7b3b00dc6497a9fc1746db99789d3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fea055235b14ec17697fbb53f0bda383862f4e8469e26563b62a9aaff748110"
    sha256 cellar: :any_skip_relocation, ventura:       "0d6f86045ed7deb34e1aa6d4941a660e2bcf76ac9c064b113613900dd6dac70a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ae53e1350d4c011dfb695982d0ca276ec95104464205dd885568f1a538f3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c7971f2688cc9861943e2d74cb185e7b8721743c1a85edf0955fb810a58e73"
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

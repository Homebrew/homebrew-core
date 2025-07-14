class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "a7c19692f78619950352e869763ca7021f1f914a55d69bdc16748510c6b70519"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c0dab1be55306a3d4256cf08ad05887f6b7c472bea4be198f3c3924d90af358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f324fa4835dc28d0fe7e80d543d40fe139a080560f0c5a48e03a701257868ca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f27beadfb7bc9ad7d2a97c71614eb84ca07b08628f51e17c356016bf5504a0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "37c0a02fc1fb427491dd11ee0908d6414a9141036b6b8dc200e0f9e0dab163f8"
    sha256 cellar: :any_skip_relocation, ventura:       "a7b218db225a1b6f3b7ac7ba95e726c1b3d2df15fbf69e42ca1d4a72a69bdecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "514d1815cdad0e242922efb932903b0c27856e34edf894efb2e834b61e54cf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593188601cff4dc6f5f5dd53229a09e7db8edf8c811687cd655716b9b8ac87c6"
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

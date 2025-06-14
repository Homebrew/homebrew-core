class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.7.18.tar.gz"
  sha256 "55c2c1f2ca8a36d35671b8253db3abf6060fe7c29e085107ebcc5ac5e9d6ed73"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cbffdd8a8e6a922e5a2497a8d1fda056937e0877d1cd69de4b07eb142e98896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7eb150140a4d77c67a1e3f00442aeec0803727cd241dab19e813e4b885a04ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9da23bb7a405580eef1c72bbc766e11a53fab50fc59d12908725526432de59c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1f1ce87e72da3a014fb91229dd3e742ba53d2c85a618963db213a5f708d8452"
    sha256 cellar: :any_skip_relocation, ventura:       "2b13235846da1e81a5fa049ba525ace3351955951da3797d7231661e5b05547c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aa8f4e6c8b03d52d4c4b05dfe52686d5fd8251ab3b08dbf85e5a1e443aeb421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79015b550731e4a0e5bdfcfafe6a703674f6cc60395cad2dc230771d2104e833"
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

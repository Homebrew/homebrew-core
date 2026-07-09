class Kubevpn < Formula
  desc "Offers a Cloud-Native Dev Environment that connects to your K8s cluster network"
  homepage "https://www.kubevpn.dev"
  url "https://github.com/kubenetworks/kubevpn/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "de703279927db399ff05aa10d81b4b7541baa1a7e384dc4fce7204c44de7c7c4"
  license "MIT"
  head "https://github.com/kubenetworks/kubevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "617ffe5c0824df71e4830c0d1185929bc56c350fc84c0610b57d4a766d062dcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7064ac0057d09b5ea826db4d1fb7b2693071ef317a4a172c54c8cbc9178d686c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d40a37d205f7d4fff7bf20013dd470e0390a78f3aeec88c4cc403112c3612e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb3e686657910354910074b5c8f8159bf2ede3b4db6a4aac892d30f0024ad1c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ba859c1c846616b254601ff8268f20f011447637082f0d3350fadfdf3b420ff"
    sha256 cellar: :any,                 x86_64_linux:  "cceae88b5527bdbbf76674061654e676daeede032a5311055c42a66d78541dfa"
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

class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.64.2.tar.gz"
  sha256 "80e170ee87e68096a3349670f2f4d7c44047f4159711950f5759a0a71469736a"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39315cc4aabafb1645c0f153e0614c9d04d93cd2849fe7f33a2f379e403e9067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39315cc4aabafb1645c0f153e0614c9d04d93cd2849fe7f33a2f379e403e9067"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39315cc4aabafb1645c0f153e0614c9d04d93cd2849fe7f33a2f379e403e9067"
    sha256 cellar: :any_skip_relocation, sonoma:        "172deffd5a5522297778b6d98ddedeb93af490cb8e8bd95321cbdbee0116b922"
    sha256 cellar: :any_skip_relocation, ventura:       "172deffd5a5522297778b6d98ddedeb93af490cb8e8bd95321cbdbee0116b922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aca74f296372166c00f43e97ac99f2610adb8d07ca6aefc119e310fb57843aa5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end

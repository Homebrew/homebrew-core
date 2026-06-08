class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.65.3.tar.gz"
  sha256 "ef9ddd75f1b77dc87e285fba47bac094543060a1b463aafcb37faf8536d17c07"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "576db089f2de933d95db8353fc668c54dddd8ff5e5f3a1514ee6c00942c65708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "576db089f2de933d95db8353fc668c54dddd8ff5e5f3a1514ee6c00942c65708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "576db089f2de933d95db8353fc668c54dddd8ff5e5f3a1514ee6c00942c65708"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9ef388ddcafbb44e07edfc635884e820d5dad61c4b422b97fcdc9948efb9b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d46915f1571cde23ca182513551d0545de6d8a5245eb2fec7cda394cb439c985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a46570ac3f6c48999438d06cd78d01e212ba9fefea2e644ff15e19f85b619fa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end

class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "cfe141f6e00816e9bddaa3d32216295176386b42d9202adbb76f48b78fd5e979"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27f42f58ffe5c116dc22bf6a08254d36cffd19a003cfc6c40724aa4a245be491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f42f58ffe5c116dc22bf6a08254d36cffd19a003cfc6c40724aa4a245be491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f42f58ffe5c116dc22bf6a08254d36cffd19a003cfc6c40724aa4a245be491"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c9c16785778061841bdf2f15a4b30a4fff0b297c1adcbc3f5ed3da406d2625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4be0543df816b7a566b47f4c81e2dc9ee7a5994f1b532c4277b1615e001cf113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250eb6f8982c5d5aa57153ad63d656f0491453e880f2ad2eb71fe2b38f7f869c"
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

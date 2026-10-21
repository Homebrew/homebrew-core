class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "044e6480297043b8939ef819bcf2d4cd9d36486d83d2f3bd3fd1382efad48c61"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04de56b03471b69353046b44f3420a2fc8e8ce33baa753669da1a6a85bfb11d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58b6dc04084f5b119327022c3d2d7f9473d639318571bc082ae8145d10004167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e61b2026855cbbc187af25acaf67f854b487901c8726c47273f557eb3344b54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4967f5363253bd58758a83a9f31b58853f5e067687462f0df842530eca274a7"
    sha256 cellar: :any,                 x86_64_linux:      "659033e71b45ed261433c744b1b8a8c034cb42cb82c53956ffab1c5c05f09731"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
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

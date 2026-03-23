class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.20",
      revision: "a1d2d4c97c59d19127b1bfc1eca3149ca0984df9"
  license "Apache-2.0"
  head "https://github.com/argoproj-labs/argocd-autopilot.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a14fad86f97d6d1434c5ed7e74b2ed3488354f777782ff105dc80765c409f45c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be3de2de809b1525f5812b4e0088cf4fb69febfe8d8f9f16ec12cab9523154e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1b8ee76391c7f4f3cecf6475ebbc16778ece41c61fddd36b49845b375996b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c24727bb33f1b6b561a40e09f2d6f04adb3184a259622063033bf37c54eb271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43d271b59cee87bd956374bdecc77a94dfeaf834889193be442c5b5473ebc484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d92042a9cbae654c5abe3821ca44e8bb65405f27872c12055e2e7f40cc466ad"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"

    generate_completions_from_executable(bin/"argocd-autopilot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end

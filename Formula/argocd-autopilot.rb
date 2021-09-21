class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.18",
      revision: "d4dc0b8b6c37ad92a133071f63b8bd2073330568"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62aec392ebe65a1d1d5828ad4e09165beef90d8c156adca562ea2249d92c0e4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b7cb2acf8bfe241b298afcd19609dc746a6f7c7101d93e6d4edbd641edf60ac"
    sha256 cellar: :any_skip_relocation, catalina:      "73b4be9d8a1c803f920b7c408b69751eec9b1fbfef822e7919f79ad8e549fcc6"
    sha256 cellar: :any_skip_relocation, mojave:        "8e6cf0dcd454ed5d5fd1288250b270c27ff84ecb4bca1063b288e52649fbe546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35839c7872546da3e558cca7080804725b1a295b4166c675d5489727bcc83258"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end

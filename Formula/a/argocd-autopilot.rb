class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.15",
      revision: "8d3b2c7467167ff031b86b7562c128e981428e0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63944e65104404301dbc74f51440599ecf28ca5488feb20a600c356858c93f26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee63d1d3924e38ff7bb0b6f9aac44a863c31691a16811fae47713d0d6ad5bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e15c00d28de569f11523bfc3442b2d22de356d361271660f44529378a0925a78"
    sha256 cellar: :any_skip_relocation, ventura:        "72eff96e6e24ea224064dc0ccd7daff2eb30a0e207fdf25bf2f433cea3c36229"
    sha256 cellar: :any_skip_relocation, monterey:       "fd49c76e314be3964cff4681ecbd945a06f9bbb710935036f13c2ecf3665db89"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bbcc402e2763bea6b34314d17e8f8d48432bca26e0bb132ffc880ce8c852624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103a8dfe674803d754e3dc87e245f5467784053166cdd5e73317309b5d21d8b8"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"

    generate_completions_from_executable(bin/"argocd-autopilot", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end

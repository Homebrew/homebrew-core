class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.3.0",
      revision: "c8d17bef976649e4dc2428c14c39e30a0f846552"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb847083a2abf163b0adc1943df12bc20695eb96d4fc2fb873e5b09b94fdaf62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76d2f5f06c7a94e389b976c930dc9566ff2441fcbe8b458fdc3188b1369d6062"
    sha256 cellar: :any_skip_relocation, monterey:       "04fa6306f4d1e897790afec4a8f2accfe52df59b6459b2667df6507fd2384681"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a6804df8ef0e475a470700366255e41d74dad96574276209fcf0b0bd4d9c84"
    sha256 cellar: :any_skip_relocation, catalina:       "84f10e068510d686b0ab071c510e95f62f25ebcf2d65caab24d7638f1ebe12d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b30c37fe481526c54f29b14fedb4769abe85d531dc1f0c9d005fd9a2a0c508b"
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

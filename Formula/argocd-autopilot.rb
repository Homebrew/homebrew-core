class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.8",
      revision: "86be25e23cd660303e33cf8abed0dfb92a8bee49"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "100477e26d585c3a7b02939722e7dc00671587dafe88ef076476b1511e9e0420"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876ca69f502c5c80a6f16c272e639f93c433cf1ca39ed926edff263f88c2524e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e256a4e72f5f82756e6d8e4d5118e94758c6b32e377ab8739555c04b4901e3a5"
    sha256 cellar: :any_skip_relocation, monterey:       "31ecab406a7024c3e464e653fed9d0d5e122498a4124e9c2ae55918f9884be7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "17390b6630216b2eba67d02c9df44bfb825706d5b5f24d1f48a762fe69f4878e"
    sha256 cellar: :any_skip_relocation, catalina:       "93563d8aa2989612dbf373a82333a421b75037aaa320a18d8995ac777bec65ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e95eeb1596185e4a2d3cd6593b6fcea531cb4f4639786bf06000dbbda0fb6a"
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

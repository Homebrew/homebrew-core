class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.5.0",
      revision: "8a4a6fffb08d2ee04b4b013253160a50ed22139c"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab8a466d076e3a2702ed3eea99459a61e8498f0aa3aaea34c3386081d9476b2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab8a466d076e3a2702ed3eea99459a61e8498f0aa3aaea34c3386081d9476b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab8a466d076e3a2702ed3eea99459a61e8498f0aa3aaea34c3386081d9476b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "903e7e7ac13fe8decbc25675f5e3351116f2e0721763d916aea7d26b73bc4655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35ed7ffed867cf97d5a72d09259298612ecc710854fb7adbcaad2eacddf6905e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c4a63ada948ff0efb097f8964f7057aad0dd76c623c09e0fe2f108d3458379"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -w
      -X sigs.k8s.io/krew/internal/version.gitCommit=#{Utils.git_short_head(length: 8)}
      -X sigs.k8s.io/krew/internal/version.gitTag=v#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-krew", ldflags:, tags: "netgo"), "./cmd/krew"
  end

  test do
    ENV["KREW_ROOT"] = testpath
    kubectl = Formula["kubernetes-cli"].opt_bin/"kubectl"

    system bin/"kubectl-krew", "update"
    system bin/"kubectl-krew", "install", "ctx"
    assert_path_exists testpath/"bin/kubectl-ctx"

    assert_match "v#{version}", shell_output("#{bin}/kubectl-krew version")
    assert_match (HOMEBREW_PREFIX/"bin/kubectl-krew").to_s, shell_output("#{kubectl} plugin list")
  end
end

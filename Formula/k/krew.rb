class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.4",
      revision: "343e657d45564940387fe028bb3310a6eaf147d3"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33b93a07f10a575d8710808a3c40e22bb89be4c5bbb10e07c91b87ba6b005574"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64f4e15c95d629c47695c6dd5d859171d2578a292073646fc20d5d99f344b3bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64f4e15c95d629c47695c6dd5d859171d2578a292073646fc20d5d99f344b3bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64f4e15c95d629c47695c6dd5d859171d2578a292073646fc20d5d99f344b3bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e83243eb10d103959aa054eaa3205217de28253f50873e93378720bb727235cd"
    sha256 cellar: :any_skip_relocation, ventura:        "ec4b6962d442c61691cfa4348ddcea989e22d18af1822123b1629ea8aae17d87"
    sha256 cellar: :any_skip_relocation, monterey:       "ec4b6962d442c61691cfa4348ddcea989e22d18af1822123b1629ea8aae17d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec4b6962d442c61691cfa4348ddcea989e22d18af1822123b1629ea8aae17d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7366454b250d713ba13a7b2f009ebcb4bae855fcf98cb5443b7f8e9f8bf2a244"
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

    system "go", "build", *std_go_args(output: bin/"kubectl-krew", ldflags:),
           "-tags", "netgo", "./cmd/krew"
  end

  test do
    ENV["KREW_ROOT"] = testpath
    kubectl = Formula["kubernetes-cli"].opt_bin/"kubectl"

    system bin/"kubectl-krew", "update"
    system bin/"kubectl-krew", "install", "ctx"
    assert_predicate testpath/"bin/kubectl-ctx", :exist?

    assert_match "v#{version}", shell_output("#{bin}/kubectl-krew version")
    assert_match (HOMEBREW_PREFIX/"bin/kubectl-krew").to_s, shell_output("#{kubectl} plugin list")
  end
end

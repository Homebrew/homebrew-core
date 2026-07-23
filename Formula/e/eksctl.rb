class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "v0.229.0",
      revision: "489531af5b30af332357bac5688592fb20c22644"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "761bee7d67abeb91288c5feeed27ce3292b3eaf3cdeae440733bf3d0b08ac443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a6314c46ea56d55cffe6b9c99e9d0a3a24454780a31960cbf391b0909ac51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92919d7b3ef8ab6af3219b204f56ae9bfe279d0a4ef606e9c76c5f04ef8658f"
    sha256 cellar: :any_skip_relocation, sonoma:        "687f47f86ea1f6ef8aeace1db3b298225b844b4e68a2078ad480170374490767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac94f76db308dc852dd2a7efff5a11465cb0a878faacef07cab4ab399f12fd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c901b6aaead79b278912c35eb8b672de365fc0378b9dc5a8d8d6daf55eec57"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end

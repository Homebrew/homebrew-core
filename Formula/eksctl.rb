class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.73.0",
      revision: "f30d401cc4eaffca1d8616c21a4e7aa84c9c3d4a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bd0409369782ef44ab44ef58403cde2d50e89c99de2451252d24a9a125aa6af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fdc53187a0c6f8bceb3c0dbfdde205fb19a4747a66df6061fe8ac2428c8a73f"
    sha256 cellar: :any_skip_relocation, monterey:       "525f2eee4ebb82dd0c565680f4afb18ef9ce5d537dafa512d6e148bf5c175ef1"
    sha256 cellar: :any_skip_relocation, big_sur:        "000fe843393e327e948debe2395013c83559a39c2ddaeca51879b198ab58e6ff"
    sha256 cellar: :any_skip_relocation, catalina:       "eaece93057c54004a9a4368d027a783617f2594dc98c09f528c11576aedab67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a5c1748ab494b9fb007338a6715a097a193f307c32f4d9a9052cff3d6f577ff"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end

class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.161.0",
      revision: "0faa0817a213e751c75149bf15094051590de91d"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f05ae42528bd83facb85602c4f89e31b6b8cd9b4ad57e0b43e7404e4b0c7ca14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9343dfbb5c6f7f1496995aff63b8c8c645d68a82e9b0f3b4fb280260c4696cff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89fb6546df9bdee5fb271ae860ccd64d66bc43de97b1ba15929f7ffbb47d47dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6861ba1d6e5af6a1769f8707cc4b9b733f5e4bb0c7edcd2f2d8c98106dbe22c"
    sha256 cellar: :any_skip_relocation, ventura:        "fdcfa4cf8ece6570e7030d85f08eaad1b027ba899d8565b14ca6e52b1edcc76c"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2d758c2fe5f7bc90dda26501f1d8e394387288d60569338ec95c21dd414b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e815c37fae0d6f0a0592d394462cfd7d0e7e756d6865b1b97d72d34a0529b3"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end

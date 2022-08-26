class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.0.1",
      revision: "ffa13178ef763580d2696a1d4b38061666db6873"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af684db2a55b3fa8864aa9dad644268a23141b9998f657e78491bfdad77475f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d52963278018570727aaa4709e30d0ce5ad595233ba8cbc3e26a7ad49a88bd8"
    sha256 cellar: :any_skip_relocation, monterey:       "fff3ae83126e4f80e0fd8e27efee92f3580789ca391e3a23e5ad612d0cb215a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c89b7dafd3f66e5c769848248d7c0a491a3d56d755f0986efebab33ab67bdaa"
    sha256 cellar: :any_skip_relocation, catalina:       "b3a6542e0959986f8bfccf69275946b45cb1ef23a73e25edf59e525a576c0a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c52c46a669fd09b84175a4b4f6657205ca9bb92ec99f2652a29e1d478e531d29"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end

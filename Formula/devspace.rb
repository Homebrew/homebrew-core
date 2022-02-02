class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.18.3",
      revision: "471bf5c24ab79ef7057a34dc5d6dd5d801356a6d"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2a36ae902fd05c87429e292741b04102fbc2421cd7083ac3f245d7981e106d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8febcc5eda39924293bdba59322b6e42caae8e4edebafd80061b4578739f9a99"
    sha256 cellar: :any_skip_relocation, monterey:       "8f3a2b6c1260a62c9776842f203d78b15fd9b8d0280afa58b6798cc338656c87"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f9b2b7ab54f2b38c1038d366cb6d7f44be6cf4e71b8575f33a83c7b599ed8b4"
    sha256 cellar: :any_skip_relocation, catalina:       "590c7c09f4739c7bcc8779ffe329e2214acf89912613a97ebf70183a8b896972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b58d06dd303829233d183823ca609c1c6ca9b4ace6ddb1db1dcca19579d5a3b"
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

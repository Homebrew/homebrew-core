class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.1.0",
      revision: "8c393e209eb3ba5387cd4b0c26f500abdc4816e8"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4bac7fdd1a421889f88c944d7c60f0d5f1b93579c24fec5c265322ef61916c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c3fd2b5aac69ea92f9c79ebb1b26dd619db12a4c4c24859b0667331a140c50e"
    sha256 cellar: :any_skip_relocation, monterey:       "f0f6be05854a7ada7abc61a875d59fd32ab485c900e4ad69ee75b6428c763ae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6ed117c5fb494aceae4011e6533844076186d697f3866af4daa76456f23c14d"
    sha256 cellar: :any_skip_relocation, catalina:       "525798649c1fadf7b7bf29db92260e9dfe99a5bedee826fb4f5bb7a5acc0dc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17db5753325b3ce99632f875e400d3b85dd47b2ab4703002ac662f86e2220df5"
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

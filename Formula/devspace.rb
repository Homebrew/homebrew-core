class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.18.4",
      revision: "8b5f107ef4b45c08918b52ac00e586bd0972db5f"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f41a80a6ddf4518be8daaaa833e389d5ca11c56f138849aaa1b462a283ccc0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164eca4c8beca77c064da2de9e1a37c96b997daa05ad78a0ad28ffe63dc05424"
    sha256 cellar: :any_skip_relocation, monterey:       "b05f88a7b686af8aa26658eb2738b270d76b9bde9522427b4a4d80841bb66039"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c0f7d917ba87d622c5068ace19ade6a96761430400df2acd7cdd3b9bffaf8fe"
    sha256 cellar: :any_skip_relocation, catalina:       "b094c13f05db4aea653f6e480156b687ad227cefb9c66c5b5d21aac5e9c16638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd3faf453f3ef1742bf8af349e74542b679c583a1001e66e74e65d5e3ab4b724"
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

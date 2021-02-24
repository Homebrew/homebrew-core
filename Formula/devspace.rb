class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.8.1",
      revision: "e236ee6482416b8a6b5aa5e7bd3c4742861cb5be"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0d90a90f6440c79a0a81e568eb92bb2de48ca8a508ac8d62f2105f7bca0c39c4"
    sha256 cellar: :any_skip_relocation, catalina: "b92b9d93e537fe8c728ed732adc430c5b35da9064190dc75ef9dfb9c8970bbf6"
    sha256 cellar: :any_skip_relocation, mojave:   "ee3c9cf84fed9334a3bc8172778ab88d7fad0e9b0d61334d99c65101fb8e7357"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end

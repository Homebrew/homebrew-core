class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.2.2",
    revision: "2b69cf7eee778c892129a7b8233ab7ecd6125690"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd8c6108c0d4a92b10bc2597797fecf537dbdcdfc86bf699c72f2c46ec504c2d" => :catalina
    sha256 "ab1966f4537597f2d82e59853d24f6c4460e878f94c97494f76db47f48d86262" => :mojave
    sha256 "ce61f2290fd664a6c5792c87489006bd72b7373a307719c30e96a2cce1e2c81c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end

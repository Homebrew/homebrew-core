class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.0.3",
    revision: "f2ef0c9191efdf98a9edb11c0d8c6309ad5f8d49"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1715909fd36a8eb28d67f945ea104674242b05ebea31139b03400d870d913d1f" => :catalina
    sha256 "fa192ad42c81c25542945cf91c637a39cbb9dac045d2d4a81d722895fb8b8ba8" => :mojave
    sha256 "73d4b124b395073d775b6ef7cd053698e2a9bfd4435b0c38ee90466bd4941ebd" => :high_sierra
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

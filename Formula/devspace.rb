class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.4.1",
    revision: "22d107c01af409b7ee65dc19675b6f11e6a5ef15"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/devspace-cloud/devspace/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9f42ee84403bbfe99330b934b901b380cee6a3c36f5a5c4646ca2de52334f7df" => :big_sur
    sha256 "4947ffd83337d4c0b4f8dcaafffc13dd1fc076aeb54f07c44b88b20303469967" => :catalina
    sha256 "dd30b78c20a37264a536dd7745aa64e6090a128d38675d3527e494767b7a7f54" => :mojave
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

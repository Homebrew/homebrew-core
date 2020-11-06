class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.2.2",
    revision: "2b69cf7eee778c892129a7b8233ab7ecd6125690"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/devspace-cloud/devspace/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c0c2d22b046ccf22243ddb25b2d07526c36de76fea7c68bace1190b870f9a4a6" => :big_sur
    sha256 "e0cea003c03d012f53b5eb61144eee361b2628caab0c663ab3c751c926aaafb8" => :catalina
    sha256 "82bd6829a7c287798f7557374ebef18c889589cce895f454eade80224ca07e57" => :mojave
    sha256 "87ed716fe7fdcd65d2914abe32502ed17106f133eb18a6c0f97085d1b67bf768" => :high_sierra
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

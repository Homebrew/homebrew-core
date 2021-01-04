class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.6.5",
      revision: "124d53b27632bad85f8c28e8604cbb008c2053cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c1bd6d55d9d7afd85586e3d568c3c0e7853058c71e0c6f88c8fec8487f9fe438" => :big_sur
    sha256 "2cb71f2373ab588337ef5a68654db92ee8155ea99dca21111993cd654da6469b" => :catalina
    sha256 "633e1602be906b8f1226f8bb13027508d7c1cb1fdcdb5bbd3c6af2782a1fae7e" => :mojave
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

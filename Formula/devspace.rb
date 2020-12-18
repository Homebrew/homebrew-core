class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.6.2",
      revision: "489897cb21257fad80a3315b9d45ac37fa11b11f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "119ec717d51d18a923e93b54fa1ec64b7a63edbafab0bc1e72482e5e2a6305c5" => :big_sur
    sha256 "97ce6eb85da18177c78cba24a444f72b6ad80d15dd5e54725f12383d35fb10a2" => :catalina
    sha256 "6b518b65b3cac7c649267d26ffb654faf7d526e42c26d259886e45cd6b4c18c2" => :mojave
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

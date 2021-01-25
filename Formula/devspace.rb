class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.7.4",
      revision: "604895a048dbdb2ed441ca9fcde12b2c9daeeb51"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c08ea2e24a54ec6846f35b9ff736ceba0ca8cf7ab7e35f460d6c26b627205554" => :big_sur
    sha256 "50342b68b8f3def3c7da89bcffd08a29a4d5c6638407a225a09814ccaf6eda57" => :catalina
    sha256 "2e080743857f98695c50a809175e1e54dc5a1dd08e65851efb400082b911c78a" => :mojave
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

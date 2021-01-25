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
    sha256 "ed68f34ac9ae4eed9669d9c5c144ab71c17a3001b5f801bacf33565f09b6d673" => :big_sur
    sha256 "b25e074c7f8c96dc252cf38a5c15cd4c3178b4174e1f5ce8dd75c0bff1221c89" => :catalina
    sha256 "5bc870b0ff49cfa0eeb2bbf5627eb7213c275c1006fe1035f60168685b3bcba3" => :mojave
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

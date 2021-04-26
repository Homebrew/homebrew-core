class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.12.1",
      revision: "e90847a5e470ae278873b4c7b41743c4b8e0ca8f"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f631eb54d40a0a8f71b6dc98a2a26ea33afbf40965fa9df16739062bdb824fd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf509c030685fc0397e396ef4055cf75158e03d10bb7ad2ca19c16eee8497831"
    sha256 cellar: :any_skip_relocation, catalina:      "c7bcc78e93c89813968210aec0562f68f640550e4d4a8d9e08f5616d74b3785a"
    sha256 cellar: :any_skip_relocation, mojave:        "b5faae72e1818074f74c07d9944ff7e5f9125ca04acd21d247e7bd1902e6488e"
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

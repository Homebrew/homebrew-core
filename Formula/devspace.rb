class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.9.0",
      revision: "d2f93907fe3f63c7fb6729c11acea66e4835e339"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbf3b2424b395043395c153d3c9d2e3fb4e7e6d69b4b6cd02be64cc6184e0e96"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2255f45cad4887a0182472c67ae75100bfe9187c5807f985bd7c470d5c54534"
    sha256 cellar: :any_skip_relocation, catalina:      "49fb25c16bcc08257ffd84d1e1f0282fe439cef501f6a04c177fdb532e683f4a"
    sha256 cellar: :any_skip_relocation, mojave:        "d36b40beba02a0d7818d8b31f92882e2986211e74562d9f62bbea4363519e286"
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

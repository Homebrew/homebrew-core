class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.14.2",
      revision: "2717502297ea653016a069ebfbfea0e3bb57a707"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "526d6d8a559aeab1f374587a5d1049a49cd9134c4ddc978f25928841556a849c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b247aa297ad429ff589f6751ca4d5c5319f54372d0bb2886f6167e4bf65934f0"
    sha256 cellar: :any_skip_relocation, catalina:      "400b82482b4a07b7252b2d177d47ab359b043fd811851b5ae58e86cc17526216"
    sha256 cellar: :any_skip_relocation, mojave:        "34dfad9d2b750f5a7d19c0b182a57bc4e7262266da2ee979f966270aeeaac6d3"
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

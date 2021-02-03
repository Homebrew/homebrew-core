class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.7.5",
      revision: "8b6f0ba2a503ae0dc69ba00c65335663904b38a2"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "25245cf909004767497290b7bbdaca918b7b4579e44b2e258a47edbe52fee154"
    sha256 cellar: :any_skip_relocation, catalina: "be297a719dc92e39657369653abcf767de5bf1f219c243b22a23b426ca87539a"
    sha256 cellar: :any_skip_relocation, mojave:   "fcf78b0430afda41ad06210da8305a3c5703aa8f0e945abf017dd19aa571a388"
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

class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.16.2",
      revision: "0a34b1427d12992bec25e55f9bdf72e54baddbaa"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52ef10f870dc87e01bfb118e4dd49420049f4fc6f0dd5f757af4548096881363"
    sha256 cellar: :any_skip_relocation, big_sur:       "05e5287227032eb72d854d112bb315fa434f4d98effacee923c67a8edddcca14"
    sha256 cellar: :any_skip_relocation, catalina:      "8c9934d47bfb44efc9a720fcfe2b5bcfab3b97d13295eca60762e4a120865cc1"
    sha256 cellar: :any_skip_relocation, mojave:        "3a8593a91425447dfe1426f3f671d1b3c5c9399b0ec67335001587b4d72fd928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b99739c78161b43d058af186d6cf5cb244929b0cef65c12c7dd6e5c689a7327"
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

class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.18.tar.gz"
  sha256 "9ddd097e97e46105f81f0ee56dd685d8ca6e7fc0076198e2bac2b79930fa4286"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c448a898f005577e7c34d2c2af8951637f322da7bf25072cf9fb936917cc6177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526bbf00709c2794072d7be4365894b6fdd01bc92551e71a36b0cd03a4c59956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4535882332cb8697229b993e16c0c5465ece85303c653eaacc4a364a0b4d7b33"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fc8aaf396cb98c6fe2c3d651db48d4d13aa8087435396a865b44a70baaee177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45ec81da3106d073826a06bf6684018d8298334caf5dd96ed5148651de4694e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8bcb4a67fdff7a3b6c13bb300c5561684297264e8f0ca91e037a4cb83d22195"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{tap.user} -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")

    assert_match version.to_s, shell_output("#{bin}/devspace version")
  end
end

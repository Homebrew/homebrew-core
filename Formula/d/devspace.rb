class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.20.tar.gz"
  sha256 "6c9e6de3fe30851959af0380ffb20dd0d07a6fe3aa35d9bfb733ac6dc5856ec9"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0495c288eb44ccfc746225597a44d43f7b3252f4dfd7918625c5de86ef2f288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7f51889211ca9fe18b2ae8237f064a19684f5b9a4425c049fff2590b1fffe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8f339325a902780d0087fe37a8b121d07ca4b5cbde4731fe43c13f04faeb69"
    sha256 cellar: :any_skip_relocation, sonoma:        "26655e1bedf0dc9dbb682be6e3859e5d4105fe8280aa9b9a26649eeff11287fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfdb89b85a1d6dd6f03771c2e17355456e594af201a0d78d15583ba1e6b67ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f898f61966e7c602acaa05e77d82b0528901125975dc68774a473f7e105ed4ba"
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

class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.2",
      revision: "294a386008d52a6ed58448f3c73e5f3ef3caeb00"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d875717180b1442da54a500bbc33834aae1d16ce0aa539676f06cf0a4ce2b708"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d9dafcee76f1cbc03eaf65669dab78e6e35925093df71f92dfa81b656eea17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6576823d6be101745cb55171dd83a9b6647f814f5f067d467839bb3b544f7ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "bd083bfcc69ca6d4c6f41c43f04003e36c9222770a539b9cfe6cda662b793f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "90aecaa31b19fa3e2cb8d6624d644241e20c7b1663e570dc8f6120ec5b12f87f"
    sha256 cellar: :any_skip_relocation, big_sur:        "567561985d4f433cf822623583e6a3e3955725d90b44e793a6698d47631588ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b5c22a0fd78c7e81e2b5658608387e609a7f66f83a5f35c61d9605049a80d3d"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end

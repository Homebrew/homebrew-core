class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.14.4",
      revision: "91f7c4668b383bb579892b7f2401e61c3b4d06da"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4cfa8ca0bc7abe6d20a3e0cf0000f489ae654600241dd5d03bcbfd46ff6eea3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f9adc24d3fc4d403371955e7c37d44225aa68af2de778ac2198fffdbecb0123"
    sha256 cellar: :any_skip_relocation, catalina:      "3a85a0c3230852815108d028ac253f2027a09e6523a26e3003fac8c44cd1fbce"
    sha256 cellar: :any_skip_relocation, mojave:        "38316f539c230bc4b4e23a6a72d9626ddbd902e4b8ed7e9e9786e7494de70430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1298492a9676535c6f6bd4e0f409b2ae6947003f544372f19389062b67ee7d4"
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

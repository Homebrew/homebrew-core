class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.14.tar.gz"
  sha256 "18c591aa592109aed55047bdf9e61f0e6f71881c99ca02f033a7e3423b2394ed"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99df51f4a087d4e49d1f743fce12f8887b68acaf7715a4769a7fd8b921642702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dba5a914731fd3e73588f80251576e49042d2b009920c25aabc4cd5e31d05407"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f74de1c0b469e7fc6b347f8b85153f336ca30f62e1611b2c55eb7c51fac6d8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd551015c61fa30316da7568141f7549304071a2e984547ebb471bf4b39ad5a3"
    sha256 cellar: :any_skip_relocation, ventura:       "2817e016ebb5cbeef2d74cfd23fb0283a66382682dd8ec77813bff5a3f62f154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c41a35f7c6d9ff1a762745a64edce27889ddde4a0a3ac8c8f8723574a44e55"
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

class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.12.tar.gz"
  sha256 "b4ce4b4b673f26f30cdc06a53dca607656b576657151f07b75253778994220e5"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "732f060db96f89d1922fd6b9310b0d34f1d45fe63e8fbe4c0977976d116ccc6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ad3d125ee2e8473d03266de891dff609823aac5c02b3300a184fdb8db803e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cfd5a1a0a86961a1f4d701a2a3ecff6431e9f6c1d179a1adbce1e0910a0b301"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb7c8f631fcb37cf83d3d4c25bc333d81baa3c32862c1ddcfcce50d345d717b2"
    sha256 cellar: :any_skip_relocation, ventura:        "f5a7338d5afe64f76a08b4b0f1624c11f15692c9644994663e66128549c9ba9c"
    sha256 cellar: :any_skip_relocation, monterey:       "afe8a3fb16464367845f2e0d785cf68cebfb988632c64d0b6240cae089c8c5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1d0f4ddc7df38dbe82b24c3b8741d922a1216aacce2c6d2410b0253cecfcef"
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

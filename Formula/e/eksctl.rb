class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.153.0",
      revision: "a79b3826a8f87040927d0bde8db3de7b3f32e0f1"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a256ab0fbb7af0b77e3d48bbdb7e01b05731c2878439e45315f2ed2ac78e3a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "901662c634e45dbe1d631cdde95b4774dff8a69b63269fb4a818af747ca318bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa6bee4a8bc4ff6af946be7347288825a7a3e9b58889f58cfb758a3dd99b0adc"
    sha256 cellar: :any_skip_relocation, ventura:        "aa2fed13232879d6908c8f83ab07c18f03951d7f66c0de2e77ff786a695badb7"
    sha256 cellar: :any_skip_relocation, monterey:       "077ebc36ca6be175d07db4ab5761c040a37d113978b8b15826a46e6e6a42dabc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e24e0ba7dd0be634c7c433a4883a8b98c3e3d4a7039523b763ece5053d3b6f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb4b3f3da190cc393310b099663ad649fb336acb023b94fe469156cd083045a9"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end

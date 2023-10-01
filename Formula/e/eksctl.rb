class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.158.0",
      revision: "4a0ee7154093157491cab35c1dbd601de5bb6dff"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "781337299fb00e618022621286e7072c45eae4e884eb22b9ec25efc02ac4468f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117b699bececa4c8f001d84c86e6c2c05d733d4f5df9836d1ac2cf18417120d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0e8741762a2329ac62e73f56001394c881ad2df02a966ad03dfff6f801c645b"
    sha256 cellar: :any_skip_relocation, ventura:        "82db720e4a2227d950421715bfbdb1457e4d50a75b20e311ce6ca07cd695a02d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ebf32148503d8aff63f66cf06b352ee3126a1ef05621fb7f2da884be1209f23"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2835cda9a159d189034175c6bba06a24eb063a9f32f20c490f07f76562fcefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b36d85087efb40529d8970fb6ca7645559f444d84e8e1290b47b764044aec9b"
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

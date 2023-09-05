class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.155.0",
      revision: "5a416eed1657930c1b313ff6bd9c7850b3834ab4"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "926329b6d067002ddae2876242c4aa45f9f87442dc84a6837c0f44c7c3a66d57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3207ea71eb6454e10be6af3f520d483187e25a7f4deba2aed175ea481b598e85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8fe83fc73f02d0049e8f657a6df1ca9f6da3ac7bece0a4a484c661547dec6d2"
    sha256 cellar: :any_skip_relocation, ventura:        "a2ca3dfe89dcb246e103ca2d433b80efbb700a76efb31c09b7f08367f2a296a5"
    sha256 cellar: :any_skip_relocation, monterey:       "27ac046f9afd2864297b737a18bf2d9a9ac5fbcb86f321d024237eba35927f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fd8a77c19c4560f44903589fef18c2022159a411aa02d4f49cc0def0daf1582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9769aae2654430eaa310eb69c42b834c0b9007851b65c048f0f369aba977f7d5"
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

class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.138.0",
      revision: "d2dcb513f80df952df0208ec132918d164da5392"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65af510837aa06e76b703715881df837c39c796395f590c7d95b5dab0097acc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4efa8d07adafab1e8501bc5815c86e9ae18e6125636224bf7b60759441c82751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4e6303c4a17dd77bf92ce9bade06af5b58c00380c6d67c3361a0f7d5f74bbb"
    sha256 cellar: :any_skip_relocation, ventura:        "d5ea39293556c99f4682929f62b0a3e1509ad6bec14c1ca08b4bc2579ba03a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "f267c016d3a706fdb5155d59290f39cbb4d410af7b6ddce96144876321d200eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aa19ceafc125953749f50e0890733afa94fd8f193761f52d345b7a1cb2a3e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818511a4a86d26b7613d157e8ba4d219864a97d193b121e821d5c2a75099de02"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

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

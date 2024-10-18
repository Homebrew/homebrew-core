class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.193.0",
      revision: "19cb88bf587380a43eb4e93157bb71cff13c95cc"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d95fadefe28914972eba24c1da737d49b9036a4645a560f319d9fcd1cb6d25a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac1a1b048b8439a879e0e7b44f2e14cda60cdf24539b1eec4264afd1cb552ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "980aeb1b9e31ce452289c8865106ec3d06fcf805cdbb035849a2b139faf4b6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbea9cd06cfa8624bccfcdd53ceeca46aca56f500cd09e0d193b15272a695d87"
    sha256 cellar: :any_skip_relocation, ventura:       "fa6d78ad773b8225ddaacd53f832a4bc5df5a6519b9fbf3efb5d3d23b591e778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda8451e7988fe76e387da8abc16b27833773c070ee67d2f548c98d30cee9038"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

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

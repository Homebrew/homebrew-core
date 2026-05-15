class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "c1cb9f2a5d35715937bbf21566d58f89fc221ab285a42ddcc30fd6fdaab2c15a"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb5d44773d58b03e384b3b5ad71564370da7e414b8d76fc4051c64652518b211"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341459917ee087c59a6a1b74852db5fe6969f2badd954d13b7ad43f3b4cc6570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22544ff56bbb5abb9e7a319b18c26805ce8dfc9522266a5b5fc30a9517ecfc4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ed7e57b1d76ab77c394a3588fc320e431154b95dcbfd575185e99dfd2245f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87364da62c17b57731b698270adcbdc297ccd4a49b8a21307be988d47f8cff79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550ab7c92cca382f5a460194edd365785e454ef6e99c1622fe2ba48fb5576ec2"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on "qemu"

  def install
    if build.head?
      system "make", "additional-guestagents"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "additional-guestagents", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]
  end

  test do
    info = JSON.parse shell_output("limactl info")
    assert_includes info["guestAgents"], "riscv64"
  end
end

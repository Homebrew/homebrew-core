class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "cdba3804df7d8c00a2af674a3fe0b24c19673a0e846e5f75ac9badf227ce52f5"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "823fd949022115e17e20e05ae0a20e233e5b343947e16bf220f3a712c5cc43ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "604da27ed9c297f794e7e4cdfd7c67529ecf244397e19d1039989931a1b53d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f4be973bcac94aa35e94417cc936ad8854cea97a2af8bbb55a8174317ac7c93"
    sha256 cellar: :any_skip_relocation, sonoma:        "98fbcdf147bd527ba38ceeae95b3d53e0f8ff5994999caff02e90346db587a1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "568a624b8a94f41d2bd189f345ff3beb01571089325f3bd7f0d297f64a2ae3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f4a15861fbbfebc7f24c23871c47c08dc560a1b1340ffd378f3e5730ecb237"
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

class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "d551efb52115ba006c1052d5c929e4d3afac363c78c9cfca6975af1f85c1426a"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08cb694c52de06d9f8350f06750caf60c7572dd2a06d60ceb4da70f711ab2155"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b12d9bf2202c887c7a96dd22189e7e12d0cdea139c4b66a93807ae7f82fbfd46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "188f9c9e4fcb9c74901dd52c9a0f47d9b53ed12e22078be30b7d2286a19c84ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1eba1933dd545a385e25219dee3c738ed0aef5b36ea70a8ce7371713e15f425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "29da26c30b2844786dca5ed57c44257e767bc2e56cd4f10416fce3d7f7d1fd9c"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on "qemu"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

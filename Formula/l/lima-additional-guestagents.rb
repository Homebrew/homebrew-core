class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "436ace830cb3e8fa512e0157a220bd8d6f826aef789c3f26d2984f0ea1e3c2ea"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "739da614e3b96094c4486ac80efbc619d52fdbe5431dcd7a3a2196758135252b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4b1a8695c00fe2ffacde4c12d6848be4b38fa26abfefcff099ccddcfdd3b055"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd468eeb259b6a7d72e787144e41afed23a99114f4347bd4902f77230a76bdf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17af2c87fa89208017b1a0264bc393504bd9cf6453a426328683e47eb893f870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "549d30e2f64d1d18a660b4fd5e1fd1e1c57821451e19539994f41bb2293cb3f7"
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

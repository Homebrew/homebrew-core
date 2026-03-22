class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "9358f4629ba01a5998327017be0470fff914b5f1bf902bbd2616ec520074ec78"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd5a8988e52320f8ec9c66336a89d7df011283438aad59af5f415a14ec2631b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c2fd0f33957b3474adba3ba415575033e6ddcb8eb3e44ca160a6646c9fff77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898500d07dfca6711f736bb199973f4a50353def583c7294d84393a7c885cbae"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c0b5454b4b962fa6740c4eb39702c22f8030995f23d33f98af11000760188cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29fbfdb1c65eeb49c677c82f1a61774af9f3dc9204d1ecb39e80d59f943c7249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d2b7de3883106ad62f2ff0dc6f94979ab3988140cf10d53250fee793a25bd0"
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

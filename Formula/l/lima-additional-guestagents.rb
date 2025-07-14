class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "5dfd2d6010457bc9e3c255cffa26ffd0aea193f7806afb46cc15afe3e2a5b352"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "903955e1f99bb3a599e323b48206e99eb4d23dcaf223380b2a7ff89062633efa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dbc2a23f254c507bc8e30eebf508af7114d1c9536906bb405a38fb0ce11672c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db878ee767a60ab08b991ab146812299d7562d01c271ad02b5529e6ee854da73"
    sha256 cellar: :any_skip_relocation, sonoma:        "996dcd596be1ad8d242644c45eff589e5ce4ba8e66458c86068240fe5abdfefa"
    sha256 cellar: :any_skip_relocation, ventura:       "6109583182daafcf2d6447155d17541961c52d0f70ddf7e0ac358b7747298cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f20112dc2d965f7cd4ce45cca3c8a97e8c1e8841924d29268c375da259f3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86fe05f0d4318e60d488a5248b0f747945b713988292ef823326e2d8fdf7d531"
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

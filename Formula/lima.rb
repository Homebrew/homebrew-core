class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.14.1.tar.gz"
  sha256 "9fac8e00325f6bbb94115850349e49ec8db9b69e4316c60fd2c1c96bde1ae0fb"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ca2316451dfb97bb86171119a1a462e132c8d8725bcb02d1aa312728da37f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca009c921a69cbd1298b0b56eba5b5fb4384f8180eb5f3376311522784cb316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f5ed9a54052b38b7154e259a33bcc2ff48ab973445b51e5747c88f4cba95a28"
    sha256 cellar: :any_skip_relocation, ventura:        "719462d3aa596e9c13075dd241275d6b55c2f53fb4d4f397d5e388bc8fae4296"
    sha256 cellar: :any_skip_relocation, monterey:       "41a1398eb207b2104883246eba3094039500587e41df880265d0db66ab870fce"
    sha256 cellar: :any_skip_relocation, big_sur:        "7968c823895a4cb62781807ea6233784cf5645e1b97a7c8dcbb90d994cf21441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9dd43a34b3583c5908ef418c83b458f83a2190a96309d109a5b288f43037f12"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end

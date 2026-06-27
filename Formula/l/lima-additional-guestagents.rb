class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "3f6dd39922eb42ff6aa497c28b7573775864a38554002719fdbf64a05033f87e"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aa328fa70cdf0ee24e53528827c111888a68ecbe2d36ec67c7262cc907a3659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c4f7dd6f19bb2cd825bb8ed019aa51d3e0ee206dbe680fda8ab71d1dcf2aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8631eb60e8441f481544946a5c764ab087bfaa4aa87335789598ce7fe2a4a42"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6b8107d8d78c9246fd397b0f9b2ee9ccf2f114d28dbdb7a90013c22775957b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030667db69450354105094f9765442505afdb1dc7171a303d03ee78e8d4f9dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1f5bdd9ef509eb444cfc813f2abc5475b55dd0e12386405c8838d5ef56c8b3"
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

class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.6.4.tar.gz"
  sha256 "3795568924c0c5eabbc6528b457a0c120383717a7f5c9a64252f032070da5afd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99868bb31a575bd92744f6bd35b38efac70ec190f9863c6e17ec3ec1fcad4457"
    sha256 cellar: :any_skip_relocation, big_sur:       "196281ae0fe294588a3bb2b4462083fdabd2589f802ab198bb47556c96863458"
    sha256 cellar: :any_skip_relocation, catalina:      "c0498394d57dff0e05c364717699bc4ad930097d249679fbf2dab0e645538a03"
    sha256 cellar: :any_skip_relocation, mojave:        "9d184e03ec4201298ec99f01e5162c398d5ab0e43227512cb077ebd47125621e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4284bcb4df0a5a84da96e4c53d9f26f08fe44f5b0a8d1df3185ce8658aaef0ee"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end

class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "82577e2223dc0ba06ea5aac539ab836e1724cdd0440d800e47c8b7d0f23d7de5"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e21b3e7d70b997b1dd6e7d996d903edffb6055339a1b6c15911f5282efd1cea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd6d9cda49a969422b199c4f40f8e30a1fc5d725a03ae4004c694dfcd3826076"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90316c2e8fd2027a848b40fe642b3d81acb20b87c8b169920c4b223ecb515d1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1807b8111dd71f1eb779fbad785beecef840216c9506ccdf9923f62980b61c"
    sha256 cellar: :any_skip_relocation, ventura:       "f8ff74c221f986226128c968eb2b1fe73c3ed16a86215d09ebaf44520a5ad0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c029ca0dc5d56d6606c1c53b81493ae3cec81d09205f9469538a6bef8843023e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb471e21416e4c445e30e96209e965677ebc99fbc9809baad2e6be3dbb5f939c"
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

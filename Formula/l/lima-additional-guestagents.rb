class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "55625e642de492827e6cf7740c095822ef8193458211e286f17a3c11ebf50a93"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "067f8a048142239ccc91b511a7dfd848298160116d8ed469375acf8a01a1261e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb644f88a4d927d40bed54c2ba8ed65a4921bcc8bb035a93902023bd2ce944ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3820af5f1f93604f0b52d810ac302bad9fddfb63da64063ca4b7bfd8c2d35a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7541e22bfc280d9520f5326dd6775b53390f8087037d0b09e5841cfaee696c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73715002140b399d10dbb0dd982465913575d76ebea2db14cbccfb49ad326a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce0179511a3227d6ee9db567e4b3d64e7bfe4c2651920553286fe8eab81b20b"
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

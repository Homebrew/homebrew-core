class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "a3efa067676ca80e780671eade074a5ff8ea080b04563f3cfd07cfc9ca4cbf76"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f463efebedb529ef89a5da7cfef6ef3893db02ff699e8d364e40f80a4315027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a0e69f048588a8c99d85b3721abb08a43bc941162519fb3c686c434156ff6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d80807fdfb8065d15bd17ee107cd9c468e3ec18558ed9d4b30d019ffb5bcb286"
    sha256 cellar: :any_skip_relocation, sonoma:        "210753b0f135d33f4bd23323de41a070568076ee0d71e8c78c364434dc0e8d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86710a4733a81aec4166829ab86420d5a1d78a90e71e61392d00c31679d6f060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071cef50fb5ac81bfee8efeed9c19de78a15e23aa06f79dbdcb27f3e6ff2edf5"
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

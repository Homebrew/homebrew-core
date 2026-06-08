class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "23fa5f4621e355236a10200c4e4f61eae9f69c805c57a107247847b51522ab8a"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9f888afbdb46fcb4cf7a98e373c0baf55441a53dcd099e2795dc71efa3dd188"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccbc76dedc0804f7b9f6346100da1663b831c7b5d457c3a21d900236a67e2365"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05fe921d750a71aea7b6d8f88bee4716c7cd2d5ef238f2834b592f9f5d512f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c198e0d596943c94fd23ce4998d1be97f474c79acd9fd8dbfc872a143f9a08c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908413afd29cc247e5d13b2dda4d8f1684e788e5185ac1cad6bb0bc695b2a001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c93327b8bc8d732eddfb31476e2ee587b5f1fa27ac410ef3e1f4fb4c48779b86"
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

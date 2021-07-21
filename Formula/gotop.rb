class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.2.tar.gz"
  sha256 "81518fecfdab4f4c25a4713e24d9c033ba8311bbd3e2c0435ba76349028356da"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68a9b93c28c45595ed4955f7d47ae753e80ad90ef2db915a01c4919d946ffebe"
    sha256 cellar: :any_skip_relocation, big_sur:       "dca175fc5fcd6cca0cdb2438adc60a5399aade2c3e1fe695261975692d5b2dd5"
    sha256 cellar: :any_skip_relocation, catalina:      "e3d3c32d0ff9c302f30354fcccbf781b630efa580e8d6dba751b879ee0f8882e"
    sha256 cellar: :any_skip_relocation, mojave:        "d72850a6aa640acce8e1df11168747586e791817042a2b73f183a341182e0a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11508939c0b39983e6e7046094889c23763979b2c80db779868843a0fb1f2058"
  end

  depends_on "go" => :build

  def install
    time = `date +%Y%m%dT%H%M%S`.chomp
    system "go", "build", *std_go_args, "-ldflags",
           "-X main.Version=#{version} -X main.BuildDate=#{time}", "./cmd/gotop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotop --version").chomp

    system bin/"gotop", "--write-config"
    on_macos do
      assert_predicate testpath/"Library/Application Support/gotop/gotop.conf", :exist?
    end
    on_linux do
      assert_predicate testpath/".config/gotop/gotop.conf", :exist?
    end
  end
end

class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.1.tar.gz"
  sha256 "314dcfc4b0faa0bb735e5fa84b2406492bf94f7948af43e2b9d2982d69d542ed"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68a9b93c28c45595ed4955f7d47ae753e80ad90ef2db915a01c4919d946ffebe"
    sha256 cellar: :any_skip_relocation, big_sur:       "dca175fc5fcd6cca0cdb2438adc60a5399aade2c3e1fe695261975692d5b2dd5"
    sha256 cellar: :any_skip_relocation, catalina:      "e3d3c32d0ff9c302f30354fcccbf781b630efa580e8d6dba751b879ee0f8882e"
    sha256 cellar: :any_skip_relocation, mojave:        "d72850a6aa640acce8e1df11168747586e791817042a2b73f183a341182e0a91"
  end

  depends_on "go" => :build

  # Apply https://github.com/xxxserxxx/gotop/pull/183 to build on M1
  patch do
    url "https://github.com/xxxserxxx/gotop/commit/5efc6ec054a65c3ec63ed5eb67631ca3becdeb50.patch?full_index=1"
    sha256 "1dd66fc5e25d49396c2be000f35f2b7fe57083a63e093f54d3565a6d43467771"
  end

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

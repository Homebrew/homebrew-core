class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/v4.1.2.tar.gz"
  sha256 "81518fecfdab4f4c25a4713e24d9c033ba8311bbd3e2c0435ba76349028356da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d248bda92bbf8651da6d63c330604f7e3fd18e754455a4efc825ecff92debdfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47c9145672b69c861a48673a6cbf28e3464151d7fab27b20fe89c9ab6cc9c0a1"
    sha256 cellar: :any_skip_relocation, monterey:       "434f0217bb8eba32e2168c5f8f91e9ca9e1628b6e92601a8204a45a045669973"
    sha256 cellar: :any_skip_relocation, big_sur:        "efd1caec91fefb19d4954b99b1041d26637e7078b645a95c46831b62cb4b9883"
    sha256 cellar: :any_skip_relocation, catalina:       "a7ddc70bd7959a66cef214cc166bd961d988d38be5c4f58a417da8411e0f73ed"
    sha256 cellar: :any_skip_relocation, mojave:         "93f01869987239375db866d1560f0fa63284532404b481168b9718593dd01b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75142f7d992b17f2789a29de44b697c63be74b5eb6605f56e65d912c5aadc9da"
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

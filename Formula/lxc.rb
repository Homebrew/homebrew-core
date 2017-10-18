class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.19.tar.gz"
  sha256 "9a82235d1bf636e77af2b25844628682d6d5c1842febb82f519f07e0fafe963c"

  bottle do
    cellar :any_skip_relocation
    sha256 "95aa8d316933199e7fe333b63bc39d850f725ad2848479d53d462781a90c8bfb" => :high_sierra
    sha256 "ca23c481d3f885e1fdaa9835b4e16a94416f0ede35ddd1c382f05c378427760c" => :sierra
    sha256 "b1e61a10fb2308750da39112c7434e0e029b3e0f4cb323e5a0ceb561eedf1e25" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end

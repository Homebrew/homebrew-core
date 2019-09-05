class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.17.tar.gz"
  sha256 "9484acb489b91f58ae8fe4518e5a09bdf2460808817efd32765ad9241ef729ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1fcb65f7bc13d5b74c491e84f33fd473a5664e1236d74d34c1e5222650edc22" => :mojave
    sha256 "991777719a9e6240585fc66845369eee33e8ff39847e4387ffa97d2a5d15568d" => :high_sierra
    sha256 "efe217633404befa0e7619813233a4da91b793019fb8ecd227a08e39fc0d904d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end

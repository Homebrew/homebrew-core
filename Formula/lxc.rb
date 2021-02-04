class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.11.tar.gz"
  sha256 "3d70bb0a07b6b343b1ff4b06f62d11147d205b30a808abc13978ea18ebed8fdd"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0784be57483c763ae066f39e422cb163aa1e62008d0d85d85cca0656aec88ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "deb9914f4689901fc70f0a917b8754e10717853ae36138dce2a0920f80698305"
    sha256 cellar: :any_skip_relocation, catalina:      "c687ec678f6f3f8b8b339982a4378e4bbdd35dbd8b800baef56265b587a6a79e"
    sha256 cellar: :any_skip_relocation, mojave:        "14f397339b103fba96c9edf3d92020efb445f54893ef78d4623b2793461d3124"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end

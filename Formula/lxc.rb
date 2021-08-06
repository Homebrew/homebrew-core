class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.17.tar.gz"
  sha256 "54524a25398e366d7ff20726e3bd59a3ac9a4da34b49a370e27ff0599e7ff5cf"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81d7c40ff0b71d24e75beec08b9484a8364709e243fc0608b3ddb0e3a686e7c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "f78ae1e135117e26e1a05f1a78b6929fe8803d1003af256bf5225baff59610f6"
    sha256 cellar: :any_skip_relocation, catalina:      "c653c38bef3df9e3384f4f723bb7f746437d3b5934e41396b2119b7b75fef6e3"
    sha256 cellar: :any_skip_relocation, mojave:        "ee349607b6dc853799695b18c899f35737a41f6658abc4f3c061e6eeb3ff03fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95ec87640f2bf9adbd18cd949564344ba84437aa70b351dc02e192ba168b90f7"
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

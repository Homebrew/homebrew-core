class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.14.tar.gz"
  sha256 "1e1ea51aec8860faae3028820d38df66f3dbf70436bc2749117c8c21c1d92ff5"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "58e629fd4511c94d5e7154702469ff7f5f6f750ac52b6519451ef85f39a41973"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a709dda8aa696938a790ce6b7db9aff9cc48e36ce7c11091ba0675370c0d02e"
    sha256 cellar: :any_skip_relocation, catalina:      "05ec66edb2dea57ea24bf40c287e0470f44309562b94ccef6d947b054950050b"
    sha256 cellar: :any_skip_relocation, mojave:        "8a125f62ea0a6c852f63d25905e17e9b8fa553a44364b07a5c30ec48525a893c"
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

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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8fe15a0f35bf12c3cb686e0eaee6a9f767aa796ef753b1a4467f401eb7259826"
    sha256 cellar: :any_skip_relocation, big_sur:       "f82b20a83820f9b22b255582a5ea842daec8b166af1f0c5effde917cdc4343cc"
    sha256 cellar: :any_skip_relocation, catalina:      "33aa7134e76a7dbfd25ff71f2939de26ae022c61b50b0340af539ae89ee42c6e"
    sha256 cellar: :any_skip_relocation, mojave:        "fc864c438c591a1ec4799c56e39632c6dfa1f7bf496113ce2fe9fcba7ca05fa9"
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

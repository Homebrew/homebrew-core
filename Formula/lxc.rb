class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.12.tar.gz"
  sha256 "3c5b87eb20e49f11084afb29224b6bad7a69bbdd8eaa99941c106149234bf1e1"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f9cefe075b08f3c341b4ed86ba1b619dd19ba1e22960c7a3ea02494eb0b3b4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0944432119962443f6500a6fc65c743bbc2e89f932e01b892c5cad66e3129a4d"
    sha256 cellar: :any_skip_relocation, catalina:      "e59a9c9812724a33a975d6ac37615aee566a89251324b17aabf8b8567bfe3c51"
    sha256 cellar: :any_skip_relocation, mojave:        "6f9dea2d34460ccdd144b08d59f9a8bca9e2988c05f7b10a46d47990d9cb0a5d"
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

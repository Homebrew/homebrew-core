class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.0.0.tar.gz"
  sha256 "cbe2ba49bb40c4497ac76b45f6a4993ea432e41f18d4a3d2b3ef69afcc6d7e02"

  bottle do
    cellar :any_skip_relocation
    sha256 "bce7f7e3a2f797b3972c94973963623c69175f2be10a19186758fc887c2bf9a4" => :catalina
    sha256 "6c78f646203d6fb861b125889f7b432aef32a1f5d28ceec46b42b1aaead632a1" => :mojave
    sha256 "a8fbb52c9ace735c520c6cd997d8330c85453298459317d2306ffedb69e55a15" => :high_sierra
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

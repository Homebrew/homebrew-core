class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.10.tar.gz"
  sha256 "4897a86dd8ce386a12d948cd2b3317ee255474b9dd4b7ff58617eb2de05e1469"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e29577824bb7dde4080ff33b3e7df929c5a84208b92f30016c742fa56b119f6c" => :big_sur
    sha256 "c5510864bc481d58d4149608083c93eaddd2b7c89795cece3205e1f69acbc03e" => :arm64_big_sur
    sha256 "804e3817c0ef27e95a3ace0541cde6ae6242d7e015fc3da349abd079b1426c1e" => :catalina
    sha256 "6c0fff4393b1ceed7761c90de3d6c4bae7fd918b47c4aa80254e6f2927dfba5f" => :mojave
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

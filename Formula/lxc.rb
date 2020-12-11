class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.9.tar.gz"
  sha256 "445e1dfcca4cc14587e083704389fb0bc4de8189597740a35ef3b7acdf56036b"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "54a721303f341f48a4dfe85983eb3ad80e36a5f1047c46087400fbdbb11a33aa" => :big_sur
    sha256 "8675b214d8d8dba0cea05084104952fce09f25ef43e0a3b1759d2b736823cda5" => :catalina
    sha256 "9a8303d460b15e9fd4c95ff980df5485efa2011fc96170f50fbf851c3158b3da" => :mojave
    sha256 "ebd08abe30cd9d0e27cad7b494b0b850c552f98770d7bf4181f7093fb09926d5" => :high_sierra
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

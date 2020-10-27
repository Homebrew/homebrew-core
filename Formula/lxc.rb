class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.7.tar.gz"
  sha256 "011745a66e971d95ada088dc42a9154028393de86871ea3ef4ff91a2976525ed"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bc7b8a9f2141a614b6df1079aed3d97508b60815fbaa7782763b9c6a63dd4585" => :catalina
    sha256 "8ba3d470438f3f6d745aaf2561b51d20c47b7a7f51d17f84a5342809d91f6013" => :mojave
    sha256 "8a4b6e7af880247651083fda117ad1b981804e879745f06e02aa66dbeca4df7a" => :high_sierra
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

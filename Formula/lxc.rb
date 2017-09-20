class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.18.tar.gz"
  sha256 "55790f952d01f83a6c59ae9a2a32e16f5cbd63ac0337c99825e9c0484369677d"

  bottle do
    cellar :any_skip_relocation
    sha256 "147836d8b755db698c56793aed7f6d144552bf11d2b4052a0313668ecf7b52a7" => :sierra
    sha256 "ae0bd030ce36d13612966de0f8569c20aae3505388f188c2bf2b8a9c15d0a2ca" => :el_capitan
    sha256 "ae2c88ff082fe1ae84893f75730699b41582630eb790fa8c26f70930c995b8af" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end

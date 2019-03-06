class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.11.tar.gz"
  sha256 "5d38ca401aedbba867f2b8b4cb491efe85047dd0729f22b31ae2feef21cfbf77"

  bottle do
    cellar :any_skip_relocation
    sha256 "72862f3c6b25d867e3bce109d5d37629a38422d84765fc7d84d47e715541278f" => :mojave
    sha256 "131bc58a107261d80f0596da606969f136ca123aff4d6a65f414aef6e163ac48" => :high_sierra
    sha256 "06016de62d29c0b807acd96312d28a9658133c231a42c86cdcf1f0f3939c1774" => :sierra
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

class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.0.1.tar.gz"
  sha256 "bdcdf74553533824cc63d6760ab3a09a5354e8bcb4ad3d938fde1feb95f4b36b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0815d976de6bb49de5ffab1b24d37e596fde50c636519b6ead0bfee77c0f01f9" => :catalina
    sha256 "caecf31475617ccc2f7badda8ae9444c1c8eb9b538fe3bd96b38c39d5623a2c2" => :mojave
    sha256 "1f124233858002b8466b6981bf1d47a63fba950b2677759bbb9498f2c67f14fb" => :high_sierra
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

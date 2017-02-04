class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.8.tar.gz" # dont forget to also change the git tag below
  sha256 "47d831933ca448e1eb72731c4ae089c26b3409a7852c7fb9e474f19b7abc258c"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "git", "clone", "--depth", "1", "--branch", "lxd-2.8", "https://github.com/lxc/lxd", "src/github.com/lxc/lxd" # work around with the go build issue: to run `make client` successfully, code has to be in this location

    cd buildpath/"src/github.com/lxc/lxd" do
      system "make", "client"
      bin.install buildpath/"bin/lxc" => "lxc"
    end
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end

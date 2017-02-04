class Lxc < Formula
  desc "LXC: cli client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://github.com/lxc/lxd"
  version "2.8" # dont forget to also change the git tag below
  sha256 "ae1a8c36c1ad6bdd50786a1b87ba6ea6a1e2cd589664047774d8134d78c75fa4"

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

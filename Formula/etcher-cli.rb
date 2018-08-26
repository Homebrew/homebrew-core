require "language/node"

class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher/archive/v1.4.4.tar.gz"
  sha256 "02082bc1caac746e1cdcd95c2892c9b41ff8d45a672b52f8467548cad4850f5d"

  depends_on "node@6" => :build # must be abi compatiable to the node version used with pkg
  depends_on "python" => :build

  def install
    Language::Node.setup_npm_environment
    system "make", "RELEASE_TYPE=production", "cli-develop"
    system "make", "RELEASE_TYPE=production", "package-cli"

    inreplace "Makefile", "	mocha", "	npx -p node@6 mocha"
    system "make", "test-cli"

    cd "dist/Etcher-cli-1.4.4-darwin-x64" do
      bin.install "etcher"
      prefix.install "node_modules"
    end
  end

  test do
    assert_equal pipe_output("#{bin}/etcher --version").chomp, "1.4.4"
  end
end

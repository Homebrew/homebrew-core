require "language/node"

class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher/archive/v1.4.4.tar.gz"
  sha256 "02082bc1caac746e1cdcd95c2892c9b41ff8d45a672b52f8467548cad4850f5d"

  depends_on "node@6" => :build # must be abi compatiable to the node version used with pkg
  depends_on "python" => :build

  def install
    rm "npm-shrinkwrap.json"
    system "npm", "install", "--production", *Language::Node.local_npm_install_args
    system "npm", "install", *Language::Node.local_npm_install_args, "pkg@4.3.0", "--prefix=#{buildpath}/pkg"

    system buildpath/"pkg/node_modules/.bin/pkg", "--output", libexec/"etcher", "--build",
           "-t", "node6-macos-x64", "--debug", "lib/cli/etcher.js"
    system buildpath/"scripts/build/dependencies-npm-extract-addons.sh",
           "-d", buildpath/"node_modules", "-o", libexec/"node_modules"

    bin.install_symlink libexec/"etcher"
  end

  test do
    assert_equal pipe_output("#{bin}/etcher --version").chomp, "1.4.4"
  end
end

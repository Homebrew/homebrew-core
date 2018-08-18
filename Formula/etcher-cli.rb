require "language/node"

class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher.git",
    :tag => "1.4.4",
    :revision => "434af7b11dd33641231f1b48b8432e68eb472e46"

  depends_on "python" => :build
  depends_on "jq"
  depends_on "node"

  def install
    Language::Node.setup_npm_environment
    ENV["RELEASE_TYPE"] = "production"
    system "make", "cli-develop"
    system "make", "package-cli"
    bin.install "dist/Etcher-cli-1.4.4-darwin-x64/etcher"
  end

  test do
    system "make", "test-cli"
  end
end

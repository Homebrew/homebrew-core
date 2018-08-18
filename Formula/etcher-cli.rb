require "language/node"

class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher.git",
    :tag => "v1.4.4",
    :revision => "cbd531e161a12721fb763b526781f66ef8237ac9"

  depends_on "python" => :build
  depends_on "jq"
  depends_on "node"

  def install
    Language::Node.setup_npm_environment
    system "make", "RELEASE_TYPE=production", "cli-develop"
    system "make", "RELEASE_TYPE=production", "package-cli"

    inreplace "Makefile", "	mocha", "	npx -p node@6 mocha"
    system "make", "test-cli"

    cd "dist/Etcher-cli-1.4.4-darwin-x64" do
      bin.install "etcher"
      rm "node_modules/node_modules"
      prefix.install "node_modules"
    end
  end

  test do
    assert_equal pipe_output("#{bin}/etcher --version").chomp, "1.4.4"
  end
end

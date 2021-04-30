require "language/node"

class ArssReader < Formula
  desc "Simple rss reader"
  homepage "https://github.com/1ntEgr8/arss"
  url "https://github.com/1ntEgr8/arss/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "48dd2fb90ede37e5688568e0c4bc0a7cc47e204535fdae9eb3b434aefe820a16"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment
    system "./install.sh", "--only-client"
    bin.install "arss"
  end

  test do
    assert_equal "#{Dir.home}/.arss", shell_output("#{bin}/arss --config-path")
  end
end

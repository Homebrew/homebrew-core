require "language/node"

class PaperspaceCli < Formula
  desc "Paperspace CLI to manage Paperspace cloud compute resources"
  homepage "https://www.paperspace.com/api"
  url "https://github.com/Paperspace/paperspace-node/archive/0.1.13.tar.gz"
  sha256 "d94951ba05bcf8f5c093503904299c6ed705111ec79eedda85081b82ee77ed8f"

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "install", "pkg", *Language::Node.local_npm_install_args
    # Use node10 because it's the latest node that pkg can work with.
    system "./node_modules/.bin/pkg", "-t", "node10", "."
    File.rename("paperspace-node", "paperspace")
    bin.install "paperspace"
  end

  test do
    system "#{bin}/paperspace", "--version"
    system "#{bin}/paperspace", "--help"
    # Unfortunately testing all other paperspace functionality requires user
    #   credentials. (i.e. paperspace login)
  end
end

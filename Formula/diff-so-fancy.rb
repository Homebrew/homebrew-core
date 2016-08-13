require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-0.11.1.tgz"
  sha256 "c2824f4661d706ef9af7317fc253c123bc8f5d88f83732d880c4504309ae7a0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc36875af0c049244294a3d55a0f7636b58c07da6a16a45b47b6e96faaecb661" => :el_capitan
    sha256 "4b1400d88283ea1e4b3a5ec1b0ce3c7c65152357f740cf84aaac97b721fa8707" => :yosemite
    sha256 "4db05f742f66f26115bc341c1e439d5c11ab4489fa479974a01d8ed15153e3ce" => :mavericks
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"diff-so-fancy"
  end
end

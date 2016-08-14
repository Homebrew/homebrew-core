require "language/node"

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://registry.npmjs.org/diff-so-fancy/-/diff-so-fancy-0.11.1.tgz"
  sha256 "c2824f4661d706ef9af7317fc253c123bc8f5d88f83732d880c4504309ae7a0f"

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

require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.7.tgz"
  sha256 "dcac2dfe58343e7cb24ea1bf3115eec329e8d694011858a06edfa9bcde8d4713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0196110b5f6f03dbaaf6bdf702210b97009ca054181ace018083d9f5f1b5df75"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end

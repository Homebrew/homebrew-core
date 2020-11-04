require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.3.tgz"
  sha256 "8635f16cfbb731b3bb170ed8c394fd2f6cb410ef934122601dcf11038be5d663"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c33c355f7605e1552c9b89bc1ac9f1cc0fa411e01a691914bdbe736f9598f3b8" => :catalina
    sha256 "cc7758a220a884f9142fc047785014239e52e62e8e919065a1f481cb55481950" => :mojave
    sha256 "1124ae7c64f33ffa3c2d14d4931f6e491e8a5ef330d0489e24a2bf05f83f42e4" => :high_sierra
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

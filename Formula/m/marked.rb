class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.7.tgz"
  sha256 "edcb08b6a56e5bfa9a1177a29943f19587771297e123694134d166546e1201b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "298cd4203cae1e5ce5dba7535202b438e798639235fa7f2e8108c2711cc6615b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end

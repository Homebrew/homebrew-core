require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.34.0.tgz"
  sha256 "8131514ac421831bfa319288b1fef7fd652d83f6524c86e66b22ab3b8ea6eb6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2f9aa8f610be0e7792aaf92162ed1671c0f2dc3244434cd1ff767eea0d33f76"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"input.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("dist/index.js")
  end
end

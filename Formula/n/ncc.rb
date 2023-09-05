require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.36.1.tgz"
  sha256 "8cd2353563a2d1d60b8f48b647aa2f0a695f3e4a265f8fdf09eb53f23b62df54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3dbe068a96ae2bef00692db5257194bd9cbe02309ecf4fda2a50cade428beb58"
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

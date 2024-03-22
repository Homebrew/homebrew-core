require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.38.1.tgz"
  sha256 "0633a7c007ddc69becffd112e5e8a2afa0da0fbf7d6e085122f2ae90e63847e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3bdd7554a42bdf4b9b98bcfd88f12b6576bd843216bb5a187dbd39da18613340"
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

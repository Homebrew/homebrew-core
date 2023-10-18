require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.38.0.tgz"
  sha256 "49b0c11121fe40682235585f7aae6ec8126bebe445cb1f91bfde395acd581e54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec61387571bbba06493fdb7da1c54f716db4a620c3283c3de1988dde3f20a1d8"
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

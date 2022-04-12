require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.33.4.tgz"
  sha256 "83634db9376555720ced0e8686d40914a9663933b7cea40afede0ab75677e2b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e6e224aacb18b6ac6b577a20a81636874235469f839c3599a9aedba82d3c3f0"
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

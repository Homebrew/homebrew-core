class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.38.2.tgz"
  sha256 "6d07c32da3e6d2e01ef03598a3f2aa6b58636473a2f43e51cdde1629610b53e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1cf16395842b95925773b2bbf6db4b6c7f00cf4bddd67eec63c03ea57e0b9f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

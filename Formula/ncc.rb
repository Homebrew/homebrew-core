require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.31.1.tgz"
  sha256 "b1cb535bc4d0f2057898a80e5c6e16bfb41b0511ef6eaef1a9e87b36a8f77ac0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45626d856d8a0f36e334edf59a8f9a24b638805730a255f65ef0abfa75f63048"
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

require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.29.1.tgz"
  sha256 "266202782c3a3532eb8bcc6b8aee27755cd44ad8607fae8b6c5f08d73403a0d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80d4e9c2aca27f9892eda13f3c75e90afbf41cebe15df62c88609e2d29dc109e"
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

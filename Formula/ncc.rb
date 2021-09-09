require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.31.0.tgz"
  sha256 "7bf37123dc0a7231f4b8a3c16bdd17d8b32fc6bb1703bf77508b0127506a48c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "748febc7a0d79636cb1343ad11cddaf9adeae25e4f706a1c0afe115549fe0ed1"
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

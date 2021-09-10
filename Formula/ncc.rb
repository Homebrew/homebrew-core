require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.31.0.tgz"
  sha256 "7bf37123dc0a7231f4b8a3c16bdd17d8b32fc6bb1703bf77508b0127506a48c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae62589d23cbd6fd0fff0f78ef26c66194045e3acdc415dd44cbff3e8b349f36"
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

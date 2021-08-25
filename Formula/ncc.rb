require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.29.2.tgz"
  sha256 "9201b1e7a848f55995d872d6fdfb3a9b0f79ae72e3c64519eccd63d8c150d30e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "237977bd267ee42bd1ff2388a30244d24d2dd07647e8e1d1b79cb448cd03ab27"
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

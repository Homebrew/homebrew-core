class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.38.4.tgz"
  sha256 "288fd3538e04a96df50fea256e849ada51c9dfcf4541a6f637c4b6eb5facb845"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c583916845363d4ffe428dbb455130e8bd1466af00a1ae834a9119425822f8d5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"input.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin/"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("dist/index.js")
  end
end

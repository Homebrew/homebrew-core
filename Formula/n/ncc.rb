class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.44.0.tgz"
  sha256 "10522cbd6c2386cc4aeee6c9b44ec0c3ed566fd7ecfb93e79cc920c6610b6a17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e855df73941de89ec1fd8be54fafa5fd7151de540d930efabf3a3df591e53aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

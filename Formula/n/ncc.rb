class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.44.1.tgz"
  sha256 "b4dc5eccb2eba78208533e4e8f4254992af65edee930518961b0ffb81ae25dcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c51e57cfda86a60cead05033945eb5b55cb0274cce4cf3f0c0fce3a828c9e79d"
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

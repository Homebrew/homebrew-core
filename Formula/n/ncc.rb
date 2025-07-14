class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.38.3.tgz"
  sha256 "c9f9d715af74152fd248220a43a2a09868fdab68f7438dd558bbb69aa487bb86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7ae75f4531238b8bf4a1b0e6359d09c834da531093d63e8b022885435f3b09d"
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

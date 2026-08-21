class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.45.0.tgz"
  sha256 "b9f6fffbe1db54510b548433170d891431bb6ce9a76acc0be769f8a7695786cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3a5e1e497e8dfbff6fc57270f30baf0ad1e55bb8ec193441dd0a986c18c4409"
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

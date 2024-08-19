class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.38.1.tgz"
  sha256 "0633a7c007ddc69becffd112e5e8a2afa0da0fbf7d6e085122f2ae90e63847e0"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "507cc4d97e59cb966e9a1da8af31b4041afea40cefef244c707bee8a65e92e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "507cc4d97e59cb966e9a1da8af31b4041afea40cefef244c707bee8a65e92e1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "507cc4d97e59cb966e9a1da8af31b4041afea40cefef244c707bee8a65e92e1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "507cc4d97e59cb966e9a1da8af31b4041afea40cefef244c707bee8a65e92e1a"
    sha256 cellar: :any_skip_relocation, ventura:        "507cc4d97e59cb966e9a1da8af31b4041afea40cefef244c707bee8a65e92e1a"
    sha256 cellar: :any_skip_relocation, monterey:       "507cc4d97e59cb966e9a1da8af31b4041afea40cefef244c707bee8a65e92e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204def702229d225311c36b5a60152f49d181e968921274198fb331ba0589610"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

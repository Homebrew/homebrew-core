require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.356.tgz"
  sha256 "74900dbde1be64a405595d0332477c2f5040202cb0035a6ec30e07e7266caad7"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94a06516724bbbe5ce86ff34e90420f7fd60b4c0ba3de6baa36cdca2a2f4b7f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a06516724bbbe5ce86ff34e90420f7fd60b4c0ba3de6baa36cdca2a2f4b7f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94a06516724bbbe5ce86ff34e90420f7fd60b4c0ba3de6baa36cdca2a2f4b7f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6a9cf88861f620723db1d9641b508ec563247c9f64e0589a6443d2f7b8734f2"
    sha256 cellar: :any_skip_relocation, ventura:        "a6a9cf88861f620723db1d9641b508ec563247c9f64e0589a6443d2f7b8734f2"
    sha256 cellar: :any_skip_relocation, monterey:       "a6a9cf88861f620723db1d9641b508ec563247c9f64e0589a6443d2f7b8734f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a06516724bbbe5ce86ff34e90420f7fd60b4c0ba3de6baa36cdca2a2f4b7f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end

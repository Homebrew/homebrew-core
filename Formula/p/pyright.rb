require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.356.tgz"
  sha256 "74900dbde1be64a405595d0332477c2f5040202cb0035a6ec30e07e7266caad7"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df6ece1331e654a46b8d59f11729e69619f753659d43384a76817c5e7351e3c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6ece1331e654a46b8d59f11729e69619f753659d43384a76817c5e7351e3c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df6ece1331e654a46b8d59f11729e69619f753659d43384a76817c5e7351e3c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6df82bfd3ea3880abf8db0ca462b3f9626d134e4f4c2529f6a1c75d95da5688e"
    sha256 cellar: :any_skip_relocation, ventura:        "6df82bfd3ea3880abf8db0ca462b3f9626d134e4f4c2529f6a1c75d95da5688e"
    sha256 cellar: :any_skip_relocation, monterey:       "6df82bfd3ea3880abf8db0ca462b3f9626d134e4f4c2529f6a1c75d95da5688e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6ece1331e654a46b8d59f11729e69619f753659d43384a76817c5e7351e3c9"
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

require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.351.tgz"
  sha256 "a557e75b53fc851314c23ee9a167101fd0a9b9bf391f4a75f6315178b3f7760c"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ef34320626bfea1d05748089c462994ef7d8ee2936e811347a1bf113032ed4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47ef34320626bfea1d05748089c462994ef7d8ee2936e811347a1bf113032ed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ef34320626bfea1d05748089c462994ef7d8ee2936e811347a1bf113032ed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cda8e660893a2d97ad652d4251be750a29a436245af1dc621c8fae7a775f535"
    sha256 cellar: :any_skip_relocation, ventura:        "1cda8e660893a2d97ad652d4251be750a29a436245af1dc621c8fae7a775f535"
    sha256 cellar: :any_skip_relocation, monterey:       "1cda8e660893a2d97ad652d4251be750a29a436245af1dc621c8fae7a775f535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf550ae6ae685d0b9443758262149b6ef080f381cb066cbbb5052e1ab757859"
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

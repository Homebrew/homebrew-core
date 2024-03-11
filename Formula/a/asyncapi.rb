require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.3.tgz"
  sha256 "f4298c5118c3148972b6ebc654af36cf5c375bcf40db167f58cb0ee92f4f082a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e7fc69d647253013a21b0a60477cd941a7bd463eee111c319530c637c323c75"
    sha256 cellar: :any,                 arm64_ventura:  "1e7fc69d647253013a21b0a60477cd941a7bd463eee111c319530c637c323c75"
    sha256 cellar: :any,                 arm64_monterey: "1e7fc69d647253013a21b0a60477cd941a7bd463eee111c319530c637c323c75"
    sha256 cellar: :any,                 sonoma:         "e490acc3c5b9af6d71629a010dc48c478ce33b997ff731bd48f081e764ebb679"
    sha256 cellar: :any,                 ventura:        "e490acc3c5b9af6d71629a010dc48c478ce33b997ff731bd48f081e764ebb679"
    sha256 cellar: :any,                 monterey:       "e490acc3c5b9af6d71629a010dc48c478ce33b997ff731bd48f081e764ebb679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7a013a4925580ea70660a5c2952164dfb15c6c9bf54d0c1ca3ebd933d409b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end

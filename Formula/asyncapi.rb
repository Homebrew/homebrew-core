require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.20.1.tgz"
  sha256 "d113b063016504d018b9d0d0affea8c0a6f1cb012ae6403396c2d2ecd3bcb28d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bf8a0cb53eae52ba5957542751fe2a7aac83a6dd6a5d305669a5133800eb990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bf8a0cb53eae52ba5957542751fe2a7aac83a6dd6a5d305669a5133800eb990"
    sha256 cellar: :any_skip_relocation, monterey:       "14fa602d4c3f1770519b8b8eb93fb58d125ca8e984ecfedcf50c91a7fc956e58"
    sha256 cellar: :any_skip_relocation, big_sur:        "14fa602d4c3f1770519b8b8eb93fb58d125ca8e984ecfedcf50c91a7fc956e58"
    sha256 cellar: :any_skip_relocation, catalina:       "14fa602d4c3f1770519b8b8eb93fb58d125ca8e984ecfedcf50c91a7fc956e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ef0d0a3b91c57254c55f5981495b1eb23c4e81c7f6e6a22d4367dfcd2cfe70"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
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

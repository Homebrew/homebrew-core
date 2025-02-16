class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-2.16.3.tgz"
  sha256 "cb22181ba38747e01505b8dc415c906bdeffd32a0d35e2e5100e106845fc8dfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d2edb7b831a3c012952b79534d03c736bf3090a0a1436880a77fc9bcbae872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d2edb7b831a3c012952b79534d03c736bf3090a0a1436880a77fc9bcbae872"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3d2edb7b831a3c012952b79534d03c736bf3090a0a1436880a77fc9bcbae872"
    sha256 cellar: :any_skip_relocation, sonoma:        "4efe8c6c85c54dd981e46f06570a5841f795651d9129d150f5d80e21ec8cfdd9"
    sha256 cellar: :any_skip_relocation, ventura:       "4efe8c6c85c54dd981e46f06570a5841f795651d9129d150f5d80e21ec8cfdd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d2edb7b831a3c012952b79534d03c736bf3090a0a1436880a77fc9bcbae872"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end

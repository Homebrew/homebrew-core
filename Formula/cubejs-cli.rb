require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.27.tgz"
  sha256 "f3846c57eae7c7a07c57aa73b5237c5ba6fa0cb99155ed09d5dd534fa7ab6438"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db17cf940d5a1c4f1b98075d04a51a981cf05d3a6bf997d55f28d56a719b6c8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db17cf940d5a1c4f1b98075d04a51a981cf05d3a6bf997d55f28d56a719b6c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "09023180f4ead9d8e3e68d431cfb1a842f7056db8dde813d939c004624ba98b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "09023180f4ead9d8e3e68d431cfb1a842f7056db8dde813d939c004624ba98b8"
    sha256 cellar: :any_skip_relocation, catalina:       "09023180f4ead9d8e3e68d431cfb1a842f7056db8dde813d939c004624ba98b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db17cf940d5a1c4f1b98075d04a51a981cf05d3a6bf997d55f28d56a719b6c8b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end

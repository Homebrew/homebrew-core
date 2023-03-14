require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.6.tgz"
  sha256 "e0c0392d061ffb7c48baaef98841eafeb97b6cc6fed6d7fb7d9ef3c9f4253089"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a4450229f4c42d35242be03ce7f618ff29692a69dffe88a2498b5cbbf8cda75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4450229f4c42d35242be03ce7f618ff29692a69dffe88a2498b5cbbf8cda75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a4450229f4c42d35242be03ce7f618ff29692a69dffe88a2498b5cbbf8cda75"
    sha256 cellar: :any_skip_relocation, ventura:        "84c81ecec4fb44df208380eb10e9e72602b99d60b364eed97aebac5996a8e268"
    sha256 cellar: :any_skip_relocation, monterey:       "84c81ecec4fb44df208380eb10e9e72602b99d60b364eed97aebac5996a8e268"
    sha256 cellar: :any_skip_relocation, big_sur:        "84c81ecec4fb44df208380eb10e9e72602b99d60b364eed97aebac5996a8e268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4450229f4c42d35242be03ce7f618ff29692a69dffe88a2498b5cbbf8cda75"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end

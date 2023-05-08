require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.4.tgz"
  sha256 "00de819381007dca1f04a364804fa9e67a83f53467f98cc81ca88038b94dc9b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d0d86b087d2996cbd198076e619c5e12373d30dce4eb35e2832a148d11e881d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0d86b087d2996cbd198076e619c5e12373d30dce4eb35e2832a148d11e881d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d0d86b087d2996cbd198076e619c5e12373d30dce4eb35e2832a148d11e881d"
    sha256 cellar: :any_skip_relocation, ventura:        "f0867716cd3b7ccf8c05ef5840edc7f93e01e0cceb21f61c6b7ef930ec4a6d02"
    sha256 cellar: :any_skip_relocation, monterey:       "f0867716cd3b7ccf8c05ef5840edc7f93e01e0cceb21f61c6b7ef930ec4a6d02"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0867716cd3b7ccf8c05ef5840edc7f93e01e0cceb21f61c6b7ef930ec4a6d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d0d86b087d2996cbd198076e619c5e12373d30dce4eb35e2832a148d11e881d"
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

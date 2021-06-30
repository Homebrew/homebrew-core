require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.0.0.tgz"
  sha256 "e99b785a75b0eb19c3279c4935ada085d19aca546780b9e6180cae877f25f72f"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c35f22c0053d09fc6dbeb60b9c899f622d0d54f439e0f27b355b6d655e775269"
    sha256 cellar: :any_skip_relocation, big_sur:       "d19e1344b6aff24b9ebeecf0da817c15d42176af784421bfc72f376a080a8003"
    sha256 cellar: :any_skip_relocation, catalina:      "d19e1344b6aff24b9ebeecf0da817c15d42176af784421bfc72f376a080a8003"
    sha256 cellar: :any_skip_relocation, mojave:        "61efd58ac51183eb25a489d635439eb38a02358680e1a94dd5db22ec7a5b3999"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end

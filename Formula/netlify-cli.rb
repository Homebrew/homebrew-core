require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.10.0.tgz"
  sha256 "018ce40a6e366138fe0f148635309a04f3bb549d693b0bf4ad0899234d8c6181"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05fc7c0d81937e1b87d1ed57009b290e768ceb0190466ddfd332b3c4335fce9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05fc7c0d81937e1b87d1ed57009b290e768ceb0190466ddfd332b3c4335fce9a"
    sha256 cellar: :any_skip_relocation, monterey:       "52254d9d89fc156fbf49ad563edf0a03a4e2c181b6d5f73b028727cbfe7618fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52254d9d89fc156fbf49ad563edf0a03a4e2c181b6d5f73b028727cbfe7618fd"
    sha256 cellar: :any_skip_relocation, catalina:       "52254d9d89fc156fbf49ad563edf0a03a4e2c181b6d5f73b028727cbfe7618fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6770903eee71435a7e7314f003b46716e91373ef48c3adfd57f4eb90f47e177f"
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.7.0.tgz"
  sha256 "21431e8a90c9ebe98e6b759608781e30d544cc875523a2d14e6f5b514354b363"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79ea6d561a2d20c87ba9f5648f9ca30d773924c8f7a61f86985f582a26017707"
    sha256 cellar: :any_skip_relocation, big_sur:       "737628a2a0dc7ad4ed5c8c1e6ff9ed68c7b6d77ec6088521793f48d668d4e397"
    sha256 cellar: :any_skip_relocation, catalina:      "737628a2a0dc7ad4ed5c8c1e6ff9ed68c7b6d77ec6088521793f48d668d4e397"
    sha256 cellar: :any_skip_relocation, mojave:        "737628a2a0dc7ad4ed5c8c1e6ff9ed68c7b6d77ec6088521793f48d668d4e397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3eef545eb22278208da48e949403ca6e281b334c5b692fb0fd7cad1b122f1b5"
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

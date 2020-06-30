require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.56.0.tgz"
  sha256 "e48c5b8748e81a0f19b17ca882e55aa055292929c2588bc27d5e40c741b0aa44"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "044e766cfc085f75d49e91ca6a8d15a703820dff29e14d6f182588c9cdeed5d2" => :catalina
    sha256 "2d9a57af0fdc8ddeb682d546c3afdf68e75c844921dfc0459d44802f31ee7557" => :mojave
    sha256 "f0e62fe9e1e60579302ba2ac3b49e4442b2031c7df8940293cd9f7feb1fb53a7" => :high_sierra
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.43.0.tgz"
  sha256 "696a2a2ba38e64d1d5d33501e16a6f62982c8e4b7f06a8db8b7dbd76817292e9"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "4bfc25a114a24d1ea70252366c783c744c722c2ddeabdf81b5ba9c7b7caeb071" => :catalina
    sha256 "22d9743b2ac6139cd138909d08bedbe37db1d0b8460dc36b1b245b1437b50ecb" => :mojave
    sha256 "7dcf7978b025d6f7718e88f56278999e1abb16c854a12b307ba979941ede38ab" => :high_sierra
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

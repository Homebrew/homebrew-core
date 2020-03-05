require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.37.0.tgz"
  sha256 "88d4286dc20be66aa6425bdb410bcdcf61549287d63505ca776d037e28ad93b8"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61a53898049847aae4ead67ebadf2b1d634e21f67ec9a7ed19209a57e6298586" => :catalina
    sha256 "c14d4e686ee7b487de790c922a8045d6ff1e9e63bd1d31071c127861706ebfb3" => :mojave
    sha256 "b053738ccd192116165556d00b061b50a2f39d9e0de1c9e6c38b86f61d6808f3" => :high_sierra
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.16.tgz"
  sha256 "2c98d5a7a8a8b5647efdccf7877b468d3ad6d1b150fb5c91162876c7ddc22f67"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12bce952611e16527dfd5d31c06344b3693f5d62fc411c7765784db282a174ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "202642311cb1710d66ddf5f45825efc25abae4cff084d4e6477ba62770c398e8"
    sha256 cellar: :any_skip_relocation, catalina:      "202642311cb1710d66ddf5f45825efc25abae4cff084d4e6477ba62770c398e8"
    sha256 cellar: :any_skip_relocation, mojave:        "202642311cb1710d66ddf5f45825efc25abae4cff084d4e6477ba62770c398e8"
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

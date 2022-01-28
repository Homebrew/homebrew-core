require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.15.0.tgz"
  sha256 "c33337d344a589e3e7190ac7ac2e3b1d0b10908b04714c6051bcf7bc41e3d28c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fed63b886fd72560ac55ae7475f87fd7094005660883d93c1049da1fd8332ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fed63b886fd72560ac55ae7475f87fd7094005660883d93c1049da1fd8332ca"
    sha256 cellar: :any_skip_relocation, monterey:       "52cdf0ef4e4afb7858e741bab75f1248dd7a1a55d952a95ae662d314082e02ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "52cdf0ef4e4afb7858e741bab75f1248dd7a1a55d952a95ae662d314082e02ae"
    sha256 cellar: :any_skip_relocation, catalina:       "52cdf0ef4e4afb7858e741bab75f1248dd7a1a55d952a95ae662d314082e02ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f05f49410c88173919b1dcd44eaa55b2ba44706e6ad3d6964961dcaeb6bf3af"
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

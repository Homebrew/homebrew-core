require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.30.4.tgz"
  sha256 "dde7ea79736fa857817b020306b7ec1559f1818c1c55d7b1eb0c868291b78627"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2a7cdd35bc02e4f1744a24013e9fd316cc139d33a3e3a419c0009996907ea637"
    sha256 cellar: :any_skip_relocation, big_sur:       "6274bbe51e5366beeb522ccd07eaa8e50b2f7d9be0a3593605a9a5c14bbf1496"
    sha256 cellar: :any_skip_relocation, catalina:      "6274bbe51e5366beeb522ccd07eaa8e50b2f7d9be0a3593605a9a5c14bbf1496"
    sha256 cellar: :any_skip_relocation, mojave:        "6274bbe51e5366beeb522ccd07eaa8e50b2f7d9be0a3593605a9a5c14bbf1496"
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

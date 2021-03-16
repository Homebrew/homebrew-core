require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.11.tgz"
  sha256 "18b3ec156875427fa312b5e57133f5baed38328ef669955091735d0caa69e90b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9a3385764f948b48b3684626dfdc0c042585660f18acefe0d8f04ffd06c4c73"
    sha256 cellar: :any_skip_relocation, big_sur:       "d578191b90383e0010916e2cdc5f6cd8290beadf005709c04733c45a1923e3e6"
    sha256 cellar: :any_skip_relocation, catalina:      "4c16e760848b97938a2b497b1204dfb9d1b6e3bf084e18e24b90758067a00daf"
    sha256 cellar: :any_skip_relocation, mojave:        "4e558c8e31a48474eb4bab481f70aaae662d46a8192d2ada65946b360dee5535"
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

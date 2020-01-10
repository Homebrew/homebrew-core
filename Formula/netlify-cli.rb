require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.29.0.tgz"
  sha256 "f606ae8a98d07071a36d36333956bdf3153e9e641f790cbdceec6c647cc62bf1"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15847bb83ea3f484dd521fa7b77770ff99db009553742481e75dbb7e94496134" => :catalina
    sha256 "3c9dbcc048d7c309ee63aabca67eeddefc5cf96305ade2657f4fbd31b91a24fa" => :mojave
    sha256 "970da247232409d84a335a8740a8b298280b5928e172a69ef17621c964ae6236" => :high_sierra
  end

  depends_on "node"

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

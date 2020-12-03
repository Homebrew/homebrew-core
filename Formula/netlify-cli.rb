require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.1.tgz"
  sha256 "5780bc2aaeaf31066eb1ff51de1f2f76470f477c16f75e4ade571fba7e4479cb"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ecdf8b04a191f59b9eae3f4c776a78e8f1c25b57561ef6bd536f6829347f8cfb" => :big_sur
    sha256 "56c56d87a92e6a4d45b6753633c2cac466c15ab830222eaf500468b311564360" => :catalina
    sha256 "4d6bf28ef5669822e247fcb9703b1f390ce8751c36263ae80a3ae4a3121e3c8e" => :mojave
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

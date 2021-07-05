require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.1.0.tgz"
  sha256 "d5e96e2b96ce13c02d5a55177911bae5016d4cd5a623d4d4d025ad66eab3ca79"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d9185413bb942523061302e69d93d88f1f7b39965c13c87d73e4a107a61a8c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "b14be636bb87f9561a5ec6509f119f92be4350ef2913c5c2dc7bfe7feb726cd5"
    sha256 cellar: :any_skip_relocation, catalina:      "b14be636bb87f9561a5ec6509f119f92be4350ef2913c5c2dc7bfe7feb726cd5"
    sha256 cellar: :any_skip_relocation, mojave:        "b14be636bb87f9561a5ec6509f119f92be4350ef2913c5c2dc7bfe7feb726cd5"
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

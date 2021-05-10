require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.0.tgz"
  sha256 "7f79ec1402aeceb763614043124cc80a99f97a157f3a497d88da2e72f5365daa"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f85509dd0e0da5f0bdf1dd2915b4a36c3db0c5e1b824a1bc08307c5c405b0d84"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb460dc5ad2c70ff165f49be5816e4d035aef85a4a35c4a03cd52af939937bc7"
    sha256 cellar: :any_skip_relocation, catalina:      "53b63fa7bdc13a2cd0b08a00cf703a4dd4e78f69cd3e485313c7ef2ee4048c8f"
    sha256 cellar: :any_skip_relocation, mojave:        "0f8aef7f12fc7b00e07f06002f95dbf9db4d14bfe6fbea33a6f8c67f7d361afa"
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.13.0.tgz"
  sha256 "b826e2d2cbd4f397598e71b8d908ff6768580caec5d9d855d8b2c17e98426e5c"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "2533ee11c178d7a815d646f9a0636306e77f8050c0c157e8cfb88c287ad31018" => :mojave
    sha256 "9be777041828894cff35e103025833f6913c32090b05a6a6b1120e0dc8033984" => :high_sierra
    sha256 "73965f6063dacd13f331079ccd125916f57cdc84a6c86466149722f2696ae40d" => :sierra
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

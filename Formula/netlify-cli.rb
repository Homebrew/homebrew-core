require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.20.2.tgz"
  sha256 "aedc3668a23bd37c22fa94387e239c4004e7e755e3b7fd3129a53d88d22647ec"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afc35bdd0e3e0f545b1b0845a89dd3c56097cae3af24f7cc2c969fb75b1ad060" => :catalina
    sha256 "65770ac39ff090dd718396a75e300b8bc82cb5a67ed74a4837ba189690562e3d" => :mojave
    sha256 "ebf69b14515be4a98010c1cc8308fa6cbbd70161401d2e187f74e6429ed01af2" => :high_sierra
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

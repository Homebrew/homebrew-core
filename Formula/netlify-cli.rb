require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.20.2.tgz"
  sha256 "aedc3668a23bd37c22fa94387e239c4004e7e755e3b7fd3129a53d88d22647ec"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31503bd441cb3791cd70645e9a862a7a4747d1c490e2ecbe817b2f4fa593a44f" => :catalina
    sha256 "bbceb3de0127338942ef2d4214194ffee8cb73e64d20159ba154d1410b46b642" => :mojave
    sha256 "78c7cec7451a93f5cb52867102d7960a532ff06d6057feda6c2739e2671e84ea" => :high_sierra
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

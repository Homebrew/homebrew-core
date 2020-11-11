require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.3.tgz"
  sha256 "f355889ccda9ca0940cc480d8814c29c1c5015a1f1334e9073d1f40801ba1434"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "41cc1ecfb10c18928eaed6ac2cfdcb26b7e0f483bc9024bbc17e320d58567e8e" => :catalina
    sha256 "e3075c02002b5ecde6c2efa796cf7a73923b61f71f5b475b9f5543baf8dab437" => :mojave
    sha256 "b4a9c0f96adfa0b3b614d72331f0e13fa6ef46aa0ffdfd300c703fc1b4523386" => :high_sierra
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

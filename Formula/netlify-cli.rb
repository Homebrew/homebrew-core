require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.18.0.tgz"
  sha256 "b1a4e42f171f8095c4a7ebf6660cdb0a2ed05662ed4d0446a032fb223a97a81a"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d18449ad77b6f92d34ed3cddd9778cb9c6afea3ef6fa889eff2b875a75ff9be9" => :catalina
    sha256 "e78937f5fd060b5bce1299515dfd7da6f591b675fc1b0fb68b631fb6cf51650c" => :mojave
    sha256 "e738f2426c1090ad08ae99e693253883d1d09eb9245e4e76036b74d8956601a3" => :high_sierra
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

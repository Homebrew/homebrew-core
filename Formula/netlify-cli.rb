require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.11.29.tgz"
  sha256 "6b013642a5a9ba86e930363f99ff650c470fea2598a1f2df9f0b28f1e1f28757"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "f4945a19015555b2695df0d1a0ad7fde050d4458bf98ce24ef9e12992e7e395b" => :mojave
    sha256 "c8394955186dbc9ad6b92c1c77216a9d2676c932b21e8a6136874734af4c8409" => :high_sierra
    sha256 "e761a191a6da6cc01cb06fbc74c01af01648583ee163b5e0b410b5bb1ed67769" => :sierra
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

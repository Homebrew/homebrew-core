require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.27.0.tgz"
  sha256 "273674741e5baca0183cdf5a85bb4527eda475d2fc15ab66fb8080206d38d156"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "686d0eb536d5b92144cdb23d0ada9b79870743b2b871ba23bd5623ebaf0e366c" => :catalina
    sha256 "29914124bb8bdf7eaea2fce6e05a84db62d65cf6520cf75f40cfbd4295fdb00f" => :mojave
    sha256 "ac69f2f1755de83f7ff072b1c7914d5fa30838875a0a018b0007d1a787b20962" => :high_sierra
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

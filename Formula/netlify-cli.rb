require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.18.2.tgz"
  sha256 "f907883ee649a660665a8d0b7c52682175e375d8ea76a9096317e67898d47c99"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16542c32b6913ddc89ba4c52ef24590f46642f3e3a58003f0a65cbd11b0dc79d" => :catalina
    sha256 "dd4aebe938ae849e0275149875c4e647dc0bdbdf20d61b6563f0d20bc2220310" => :mojave
    sha256 "9c07f86eab1963328d6eac735e7dbdc3973be1ceec6cf0d5d6ea39c0e9aa547d" => :high_sierra
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

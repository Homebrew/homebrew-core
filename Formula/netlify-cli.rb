require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.41.0.tgz"
  sha256 "07d0affd5636a2bff20571462dbd5f1e1dcbc23027cdbe22d97c06de8458f819"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21545c11e6584886ac1e2ca573ae5ca411bc401d0ac3abd23e2e3ef14b7875ab" => :catalina
    sha256 "d49597456e4c0fc3d2eb49f0aef10850fba8b9f302a270b2f669ea1cb51e6290" => :mojave
    sha256 "bdac661004604f3eba5abad549a7559b19f304f8599ecd167fdbca920eaf3faa" => :high_sierra
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

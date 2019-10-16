require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.18.2.tgz"
  sha256 "f907883ee649a660665a8d0b7c52682175e375d8ea76a9096317e67898d47c99"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce3b5ae1f62af63c51da25f2e91e0d8ba88d788c65625f301f3a533db74ebc01" => :catalina
    sha256 "476fda42152b279afb3e851ec02cc0d5fb678130a0ffc701d68e36e0f989a2b6" => :mojave
    sha256 "c1092f7eebab9bea3194fd171d380694a689bac1e98f20ed2c685ec7fbf5cb66" => :high_sierra
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

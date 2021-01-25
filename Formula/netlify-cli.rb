require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.4.2.tgz"
  sha256 "b8e57777f837447e4afe95857c0ab6cbfa2f1af6ff00141d1bf65fc90f8de32f"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fffeba3466c6887c9c391b71db9cc38bc7946885a2ff0b970ebcac1cfb5dc1a2" => :big_sur
    sha256 "95215f8ccb90b12430419c13d1d5dc5debfa561e801bae572f5cb4b127d5c2a1" => :arm64_big_sur
    sha256 "99491e268e4b47c2e10fc35d3d73c3fd974cb3aa4fcee1efeb9bf4dbe1f468e1" => :catalina
    sha256 "a27b84cf22134c4694116cbb77ee9e9c9969adf29ec70d44876b59078e3ae2d4" => :mojave
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

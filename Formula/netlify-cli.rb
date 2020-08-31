require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.59.3.tgz"
  sha256 "bce213b07c871bcf22407a8ff8189473aba5d725bf2a4cad88a54648acbc9ece"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aa0beca3206358c08be491cad26fdc2b0056b0cde05cfaff27ee823606b432c0" => :catalina
    sha256 "b0078fb0adb47d45e9de253e5fbd8ca52f1e134c7c9479d7a2b2e369cd6d6a7e" => :mojave
    sha256 "fe6b7c882c2a3a5b8f1540b8b61e55a9e732b4cb0c15233a3f3e72351c8656e0" => :high_sierra
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

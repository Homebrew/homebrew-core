require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.52.0.tgz"
  sha256 "b82c9bc99a7d63230f01c297fee438aad85daa78d7812e5fab0d8937b4712688"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d36004db2e924c2a81bd71a32ec11ba4499f27b47bbe5e52b2396bd5c7883bc" => :catalina
    sha256 "16529fd384f05d77e7159284c87f91a5d254216fea88a7b1c5838386d992fe22" => :mojave
    sha256 "56cd0daaa8c5ce7bca53e0b9f103568d4945cbd3a8089e4c5b42dcb8e5d2331e" => :high_sierra
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

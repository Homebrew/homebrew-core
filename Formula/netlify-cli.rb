require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.1.10.tgz"
  sha256 "4623ebdba24141bea7c2d0bf88220f174ba9353adee39a262505f7f36c0870c5"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da1e22a74006254488d4a89e0cb386ea44c4e42236937d9b3740c2f8bc7edfdc"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef2511e772d5c9f8b3d692cb0756f461f48235bb2f372d7efde9b8b4a16f5300"
    sha256 cellar: :any_skip_relocation, catalina:      "ef2511e772d5c9f8b3d692cb0756f461f48235bb2f372d7efde9b8b4a16f5300"
    sha256 cellar: :any_skip_relocation, mojave:        "ef2511e772d5c9f8b3d692cb0756f461f48235bb2f372d7efde9b8b4a16f5300"
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

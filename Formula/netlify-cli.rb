require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.30.2.tgz"
  sha256 "a982bcbf9c7ad1d3d02fda6bdd5d97beb44f27923912de3a57436a0e724daa60"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "878f429f7ac7848f8321916e69a54715c14db1d5212afa1b4021a34ee6cccc8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "013df3510efabe6aa01e4ea3645bbfaf095c4888ff14a2560210dc8f4c1040f7"
    sha256 cellar: :any_skip_relocation, catalina:      "013df3510efabe6aa01e4ea3645bbfaf095c4888ff14a2560210dc8f4c1040f7"
    sha256 cellar: :any_skip_relocation, mojave:        "013df3510efabe6aa01e4ea3645bbfaf095c4888ff14a2560210dc8f4c1040f7"
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

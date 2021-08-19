require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.6.0.tgz"
  sha256 "ed812118f7804de16cd6c6e3fd276b7225b25157fcfe55ca6993f65254166aa4"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7611638a29406d6ddb10276ae998d551fa58d2db8a8c48274789fffce19fa769"
    sha256 cellar: :any_skip_relocation, big_sur:       "70f382fe3987f19ffc5dd06977bf5f81ecff64a2e1b910d40a4215b17b7eef61"
    sha256 cellar: :any_skip_relocation, catalina:      "70f382fe3987f19ffc5dd06977bf5f81ecff64a2e1b910d40a4215b17b7eef61"
    sha256 cellar: :any_skip_relocation, mojave:        "70f382fe3987f19ffc5dd06977bf5f81ecff64a2e1b910d40a4215b17b7eef61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd3491e57f57bbde652e78782d51c5a28b51f4ad83a5fc4d66ef1a1eb3ab3d5b"
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

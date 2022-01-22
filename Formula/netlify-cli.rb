require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.13.0.tgz"
  sha256 "22b06cb8981c663842b0121145760e58a31a8400e77d88c85f7225bdf58a49aa"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98f76756f8356b6440900817e97be2bb6af241da3a706a25ae3c2bd5d85d198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f98f76756f8356b6440900817e97be2bb6af241da3a706a25ae3c2bd5d85d198"
    sha256 cellar: :any_skip_relocation, monterey:       "59b13f45f1479ac83813650d8a5e9624597ae74b64b931e9759de334b697f546"
    sha256 cellar: :any_skip_relocation, big_sur:        "59b13f45f1479ac83813650d8a5e9624597ae74b64b931e9759de334b697f546"
    sha256 cellar: :any_skip_relocation, catalina:       "59b13f45f1479ac83813650d8a5e9624597ae74b64b931e9759de334b697f546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946f70a73349ea7ddd56eb364377b47d8bef9add672bb0d166f597b2846dc2bb"
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

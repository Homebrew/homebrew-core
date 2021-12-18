require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.1.5.tgz"
  sha256 "c0b00a439125868ee9bcbc3dca056307f293cb914619aa98fe2d6998382b690c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce4319231857ca94a2c17a6c83f9c53a0aa0ea8da2d98f884b2c981bde6734f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce4319231857ca94a2c17a6c83f9c53a0aa0ea8da2d98f884b2c981bde6734f5"
    sha256 cellar: :any_skip_relocation, monterey:       "3311c51d1318d7776088fbac67d3d52c96459ff02e0cfc54bf68a0c344dd2faa"
    sha256 cellar: :any_skip_relocation, big_sur:        "3311c51d1318d7776088fbac67d3d52c96459ff02e0cfc54bf68a0c344dd2faa"
    sha256 cellar: :any_skip_relocation, catalina:       "3311c51d1318d7776088fbac67d3d52c96459ff02e0cfc54bf68a0c344dd2faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091e409074af9cc07b758e86ae6b9479f85a1e400e6e4c923a2c8090ae9ecbe5"
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

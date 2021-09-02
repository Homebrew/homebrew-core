require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.8.5.tgz"
  sha256 "eb80c606b83b97a5a693289af81cf8099abcd2de56694cdf74ef9abb40bb6e6a"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce0dd7ef6ba82b4025154f56a49d511c7894363b4391260dec4c4f1051aacdd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f48fa6d16c117127c921ffb8faa2dc184417770c9d310a0fdf48f44571559f4"
    sha256 cellar: :any_skip_relocation, catalina:      "6f48fa6d16c117127c921ffb8faa2dc184417770c9d310a0fdf48f44571559f4"
    sha256 cellar: :any_skip_relocation, mojave:        "6f48fa6d16c117127c921ffb8faa2dc184417770c9d310a0fdf48f44571559f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0953c7d4fd2b6c30ba1ae70cd8384d9b4137dd042191b761a256a91f761c80"
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.27.tgz"
  sha256 "eeafff375ce1068b8aa7f18ec6b487178ea0697b12b1e0a4fa55dccdc332d187"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "920d4e7e91b90864649e3e5d0ebc117be7aa833bc9a20318a6c46aabe17eda3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "87a46e979ddf1a1d72ad74a4e6e37f0d88b98b7554fc612716bee42ed742cf55"
    sha256 cellar: :any_skip_relocation, catalina:      "87a46e979ddf1a1d72ad74a4e6e37f0d88b98b7554fc612716bee42ed742cf55"
    sha256 cellar: :any_skip_relocation, mojave:        "87a46e979ddf1a1d72ad74a4e6e37f0d88b98b7554fc612716bee42ed742cf55"
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.57.0.tgz"
  sha256 "b9af8cc3428c03e7d82a3e0ac4200263e16be5bbc04a8622a1984471d30b51e7"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91a9b111fcf8e9369c27627dca3649ba5fbb89e60aed80b613bbf2ce84973581" => :catalina
    sha256 "65fde49929cb622469c83777e405126df49a96b0b243d984d7c714d56b9486ea" => :mojave
    sha256 "2bc96aa52fb0758cc9756e40a2d20f8220dae9d1796a2892bf021a6dfecde215" => :high_sierra
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

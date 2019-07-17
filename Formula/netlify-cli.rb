require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.11.25.tgz"
  sha256 "1e294a6f0acbbb0fdfec4b77fb3c805d516905cf3bc3eaf7219e46e6058d98d8"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "a596b19ff8bd8281b14f6d4f77823dca3c734f6429814faa00d299129f35de58" => :mojave
    sha256 "4235ec62b2ae6c9fa24eb8f47a9ac5041df79da51c872f11b35f3b21854fed9e" => :high_sierra
    sha256 "c2374d1ed5e14cfc9fae53c73a064382c744133046a378798d9c98f466a18de4" => :sierra
  end

  depends_on "node"

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

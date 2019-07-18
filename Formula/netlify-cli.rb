require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.11.26.tgz"
  sha256 "1aea15977411f85c9d20e7345c9d2a1e43bee9f8c55f7b4b0033c24f0a010b61"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 "1bb88df8146a17efb335dbf393ac2ab0bc4a263549bc47dd8cf0be271dead60f" => :mojave
    sha256 "8730f82a8c8ff699735763ab2eef6d88ae8ab7a8398827d94d8dea751dd515be" => :high_sierra
    sha256 "0aec681d0c6f0de93d67ba16156b913a31c7f70447b8b77e51d27184af54d5bd" => :sierra
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

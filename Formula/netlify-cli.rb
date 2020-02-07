require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.32.0.tgz"
  sha256 "a7164a5e488c874886c8555a912730265f445b9c6994dc0c4b0d9a0c0c8a7431"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84e8f07c902f6a0af920050bb04184971c101227bee2e4bd0497710b56899c4f" => :catalina
    sha256 "2e9bf73b6c2d10de2d8c1bac1ec7f5a230e52f53806c26ea8fcebd229c63cdc1" => :mojave
    sha256 "8e7e207980f8dedb75a4c3ffdebef3e27561d61b32961a797eb90327ecbe62e4" => :high_sierra
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

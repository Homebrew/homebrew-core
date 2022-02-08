require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.18.0.tgz"
  sha256 "e744fa1ef9aef6a4ed34d2937301a0a70da3ca54a955526f001eda434bbe5900"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dea076de9dfc0917dc9a579b00f5ebb8bdfeebbd68c9fb9a9996b498e75709d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dea076de9dfc0917dc9a579b00f5ebb8bdfeebbd68c9fb9a9996b498e75709d"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6dc15d3b2a4763aac40b689c2619385692f3fb6033967a6b1e6846d067986a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc6dc15d3b2a4763aac40b689c2619385692f3fb6033967a6b1e6846d067986a"
    sha256 cellar: :any_skip_relocation, catalina:       "bc6dc15d3b2a4763aac40b689c2619385692f3fb6033967a6b1e6846d067986a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908ba6199db7a341e1045b6dc085c44ef0ee51c0f414f26293908e748a966965"
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

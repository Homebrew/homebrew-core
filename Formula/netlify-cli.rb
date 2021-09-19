require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.5.tgz"
  sha256 "516269e4e7ee4ebed1568b49475114199458846fcaf7ebe02ecf8fa1ef3cd9de"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0536f3f71170d350de2d59ceaa9de9788164856d631bd869e0bf49831ee7d3c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "39637ba7c0433cb79c5947eaef69069011b18de31537969a0de692293d30e25a"
    sha256 cellar: :any_skip_relocation, catalina:      "39637ba7c0433cb79c5947eaef69069011b18de31537969a0de692293d30e25a"
    sha256 cellar: :any_skip_relocation, mojave:        "39637ba7c0433cb79c5947eaef69069011b18de31537969a0de692293d30e25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372c40fb11fea8b646f80ac69bcb89d12f4a34485f3a0a5bab814c12255e04bf"
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

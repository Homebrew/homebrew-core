require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.25.tgz"
  sha256 "aeae27c52cbaf3a0ed9522abde6e02f3ebf4bf26dd3d615ba0d00f3538b7e3ac"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1289cca3f52786168e6ddb705380d1ba6ffa1f112ca7240332be853c2b2476eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "51e7a150350a5ad40b9ce0b6926021c5dafd96ed705a2a7aa4c2c05388ff7584"
    sha256 cellar: :any_skip_relocation, catalina:      "51e7a150350a5ad40b9ce0b6926021c5dafd96ed705a2a7aa4c2c05388ff7584"
    sha256 cellar: :any_skip_relocation, mojave:        "51e7a150350a5ad40b9ce0b6926021c5dafd96ed705a2a7aa4c2c05388ff7584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57adc6585d365210832dab7455a87a81428a38312679e06898e5924d9908f569"
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

require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.13.5.tgz"
  sha256 "75320f62b3d945f7a74555af8a84b6710d4b119c043e7a62822545c0694cd472"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fa83b6e08a2f5cb39f88719742082cc3ca851d2ad995fb6461fa835aa292015"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fa83b6e08a2f5cb39f88719742082cc3ca851d2ad995fb6461fa835aa292015"
    sha256 cellar: :any_skip_relocation, monterey:       "36b917c21c782dd67e5116b9556007a9b4db57a0b1e6745b7e2922f2c80b5fd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "36b917c21c782dd67e5116b9556007a9b4db57a0b1e6745b7e2922f2c80b5fd0"
    sha256 cellar: :any_skip_relocation, catalina:       "36b917c21c782dd67e5116b9556007a9b4db57a0b1e6745b7e2922f2c80b5fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3b0ddf366394fe75a9825ad09a15651250a717337cee8624312fe7eccbf817"
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

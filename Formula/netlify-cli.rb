require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.30.tgz"
  sha256 "0d6cdf70e2072758f9d0aa03bd1dfa35dd43ea69b9d92f6d9369aa2b80cc763f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d828a17077323e75b49bea62d7cb3157f3da8d3e22b949c3c019992c16968f96"
    sha256 cellar: :any_skip_relocation, big_sur:       "7447e0b1ad8a1aa396172447fdc16fc5e94e78390582805888330deec89b7022"
    sha256 cellar: :any_skip_relocation, catalina:      "7447e0b1ad8a1aa396172447fdc16fc5e94e78390582805888330deec89b7022"
    sha256 cellar: :any_skip_relocation, mojave:        "7447e0b1ad8a1aa396172447fdc16fc5e94e78390582805888330deec89b7022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ace2a40213ab634f511bee043c35149681952489c3bc481d3272faac70ad098"
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

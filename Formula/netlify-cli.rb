require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.20.tgz"
  sha256 "789a9f598652278f16b780033dbff785c3778a22bd04974c3e08b62ef23a68aa"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "647c81931cdc5a3075b386a7a59d1fa0d68d560071938c3f3fcc418abf1c5556"
    sha256 cellar: :any_skip_relocation, big_sur:       "191f0f092e7713694c52ad67be2f01c9327804768bf9048bbfccb7dea0e92851"
    sha256 cellar: :any_skip_relocation, catalina:      "191f0f092e7713694c52ad67be2f01c9327804768bf9048bbfccb7dea0e92851"
    sha256 cellar: :any_skip_relocation, mojave:        "191f0f092e7713694c52ad67be2f01c9327804768bf9048bbfccb7dea0e92851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46415d742f1edd731c33a451d354f8a1e0b24facfbbb935624d3228f7d42ebe8"
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

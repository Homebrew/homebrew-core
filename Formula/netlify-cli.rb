require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.31.7.tgz"
  sha256 "887fbfb834ddb4f8f03312582ec853433c2b4101a73a51c5ad199a16f3b04ffe"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d78afebab85fdfef0a57440709360eb6ece1ffddf4493ce7493e24bb1c07f9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8cef9c73d917345f6f8715825d9d754f8de7ef1ee779d2ca3a35f22902c9c8db"
    sha256 cellar: :any_skip_relocation, catalina:      "8cef9c73d917345f6f8715825d9d754f8de7ef1ee779d2ca3a35f22902c9c8db"
    sha256 cellar: :any_skip_relocation, mojave:        "8cef9c73d917345f6f8715825d9d754f8de7ef1ee779d2ca3a35f22902c9c8db"
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

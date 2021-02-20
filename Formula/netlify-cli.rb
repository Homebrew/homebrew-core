require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.8.1.tgz"
  sha256 "e9d23aa1bf0e9de6b07fbb4a963ad0cd6dd4033ae7435d7d7a20740c68d47a46"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e49b006c955cac1398c27ce01efb3c707dfe35e05bed4a832825dac2e06286f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "f916a1c19d4e6865488f6908c1952d11bc1ec422aa3e997575e0a23bac99c3a0"
    sha256 cellar: :any_skip_relocation, catalina:      "739cbc13e1a40219c17553fb0e9a60f7e524c35e7dd6611610f5c4c0290a0c4b"
    sha256 cellar: :any_skip_relocation, mojave:        "db5b223a06d2e9cd65057be733376681a8f2c8606e3b1c21b036a11bf5ecc453"
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

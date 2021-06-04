require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.34.0.tgz"
  sha256 "d0ee6b1945b49aada1d8dbf652f5a1f046d6c672c710f80076766b85d6eb1c52"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a920f18b4751e15e822f059624e7a3ce0fda4d306023fe785e0ceb2caf06309"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f638ca178b15f57cc1f4bbd3307a736fc620fca398213421d2fb3ec3c8d29a8"
    sha256 cellar: :any_skip_relocation, catalina:      "6f638ca178b15f57cc1f4bbd3307a736fc620fca398213421d2fb3ec3c8d29a8"
    sha256 cellar: :any_skip_relocation, mojave:        "6f638ca178b15f57cc1f4bbd3307a736fc620fca398213421d2fb3ec3c8d29a8"
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

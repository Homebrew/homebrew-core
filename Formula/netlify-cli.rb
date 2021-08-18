require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.5.5.tgz"
  sha256 "419cae061b1432e04b638688e7f3a5c2fc6aa9b8420103de01db4db20af38e44"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8fd968a3d1e87cb29a6fcf81f8eb4d4f2fdbf5e2d1861ebd890112bef9ded13e"
    sha256 cellar: :any_skip_relocation, big_sur:       "13b6e003c4b43031bc3b524eda0436455635b3eee1eb2d1699120530dfc5ab86"
    sha256 cellar: :any_skip_relocation, catalina:      "13b6e003c4b43031bc3b524eda0436455635b3eee1eb2d1699120530dfc5ab86"
    sha256 cellar: :any_skip_relocation, mojave:        "13b6e003c4b43031bc3b524eda0436455635b3eee1eb2d1699120530dfc5ab86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057ce8c89ff3cc122fbf19a5de560f19bb14e2071b1935d950a1fe84992c4559"
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

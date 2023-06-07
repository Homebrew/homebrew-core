require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.3.tgz"
  sha256 "5bd04175c5d075b58448cf4fff3a2c6a760e28807e73f4a8f1ab0adf14d7c926"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6499b7d274062701dca2cb7edc75671dc61f776f0e440b3a40f4b6247fc9a08a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7bfefab47efb569bebb4e3c5ee45159c8f26aaf6fda49b74015bdc665be8dcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7bfefab47efb569bebb4e3c5ee45159c8f26aaf6fda49b74015bdc665be8dcf"
    sha256 cellar: :any_skip_relocation, ventura:        "2333eb41aa92877e06af2004511c89a39cc78f7885c37f0d9159ae02d3008b4f"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9f489110a6841a2306afef5b77e160e34e650a1fc63978698d54a982358a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd9f489110a6841a2306afef5b77e160e34e650a1fc63978698d54a982358a8b"
    sha256 cellar: :any_skip_relocation, catalina:       "bd9f489110a6841a2306afef5b77e160e34e650a1fc63978698d54a982358a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8a49fe170889400a5976142f6131b06f4f3d0f366a9c821beac1997f29be6f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "Error: Width must be multiple of 2", shell_output(bin/"gtop 2>&1", 1)
  end
end

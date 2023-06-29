require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.7.0.tgz"
  sha256 "92492cb80421b604f5351548975e08127699a1cf525d8687afff6c048e472d7e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "6a9e7c414b26a310ce60730f384a231afc76a312b7232b0743f9982d687a1f76"
    sha256                               arm64_monterey: "94beecd46aa5e4e347793679b712d55cddc6e771bc53f81ae62c096ace61d82c"
    sha256                               arm64_big_sur:  "663c288dd977f4da885cf1a0e10e9490f92f7c26519e7aa799590615db6f1db0"
    sha256                               ventura:        "f6ca30bd48a73de50d8c70f0f711833881ac1e886648e3938c85cde25adc69a9"
    sha256                               monterey:       "5f86b5e4231a55905be1ef7b388434f89a9ce6e83df5e40164b27a636dd15db7"
    sha256                               big_sur:        "bf00a236f0d6a7e4d3edf6dc0ce2b275dadd6555d5a1e8f8dcfb2dc0fb2988c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51a451d561cfa23483d9d480a72d1798d1b9b5a0684564d7979405eec378185f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end

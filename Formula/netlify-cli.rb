require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.6.0.tgz"
  sha256 "1e42363052b82a8f99d60ccc228b574f8830c5df64683095c719b63347fd73c8"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "a9becd711e72d662a7ebdba166ee7daf2f28ff8357bffaacaf7e75bce38f4a4f"
    sha256                               arm64_monterey: "2f64bf8131ef52ca21e74f7cba610932db4d89b507d0f02ff3ba4933dc8aaf97"
    sha256                               arm64_big_sur:  "d54afe888fadb2c8f459bf53da8351219a36932471ffcbf6176b734f215b88e7"
    sha256                               ventura:        "8a0da6ed3ffb41aa9d26454b48f80474d4ac0bd4a73c009fc437b3dd62ef171f"
    sha256                               monterey:       "cffe3e9308b284b0374e650bb7c0e9a65d0e7fcd8a5b8937c4b0a098d484ade5"
    sha256                               big_sur:        "9b63e89a63013c67dd287998d567ccd37f5959b6f0ef21ea4b90ab1082dca974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d6375ef5d169072e2443219081bbe7e356a40388b6abf4a1623fa60eda999c4"
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

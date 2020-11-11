require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.20.0.tgz"
  sha256 "52f284a031c8e07a5c03eb42aa80b69728bdf32154d573e415fd20741030ecb1"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4698592517df27cc194e9d3d82e0db39116152aea1d3d2b422a487289416f9cd" => :catalina
    sha256 "2372ca1baf46095d95895019ae1deb39ed8f044b61543cef11dc193819bbdd6f" => :mojave
    sha256 "9aecb06ab1e9c4bbf47ce42143a91399c1f86fd6ad2ab6c7a3c88658348e1abb" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end

require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.16.3.tgz"
  sha256 "8e6420ba2175f4878b05672dce1d6d42301d46626bed9d57c8bc4a79f1666cd7"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "181c9f267392968cc0916bd5f6a705ff66e6b8f6ac7c47c95aecaaead9f343cb" => :catalina
    sha256 "e0fbc7d56a19d3ea8d97146afaa0c3011541f8c7c93ff11e03a6fc70bfe0e97f" => :mojave
    sha256 "15d9c3e687ca16bf3864bec7e6e58269997419ce2bac8bf6a8129c2dc3ab111a" => :high_sierra
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

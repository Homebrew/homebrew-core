require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.22.4.tgz"
  sha256 "9661eea17000fa5a6d3fd088546175d38ed4da55be7ab723f04e84eb2f7e97ca"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9d704496168e4bb4e15a69f3adf4aa8d606589d123355258a0475af3a6fe0426" => :big_sur
    sha256 "95153a51d3ea6f27b59dfd8b52c9515fccc84dc92060be47a886a3a2294d6d2e" => :arm64_big_sur
    sha256 "71ac21c726d6bef18fb9233490713058520e78f7e0dc94def646fe1f9d37b8b1" => :catalina
    sha256 "dd33314961d6554e29e176d715a24db87a344f65fe0cad43251d198701c54d57" => :mojave
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

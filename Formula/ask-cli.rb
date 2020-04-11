require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.0.1.tgz"
  sha256 "8be5a30551024a8e790f4a2bd42bd49a9346a448b5bd7db0870967b8710c22e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "505b635741f00e25800b662a7b0cc46c9e0de938a37c14d86617cae443c3d402" => :catalina
    sha256 "de616f21e7a5da829ee8fede706ee58e6f9531fe86a73a0deb2dfc87feba53ee" => :mojave
    sha256 "603209031c3b0f862271eec14df4c8a93684faf5b9269530e9eadb1f18a9cd9b" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "cli_config not exists", output
    system "#{bin}/ask", "lambda", "--help"
  end
end

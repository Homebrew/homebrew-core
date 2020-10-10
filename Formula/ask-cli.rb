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
    sha256 "9e4df6ff6d9cb85dd27668f31b85a6d28b211e56aa140756bc0fffd864b0aea4" => :catalina
    sha256 "58c1e411145f84b704dc3a5dd61c4026511221110a8abbe65231118930abdb6b" => :mojave
    sha256 "5e9f99a41065aa9ad09e67d8370ea26f69bc44b6a0cfe447d12929d3d0d87e30" => :high_sierra
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

require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.18.0.tgz"
  sha256 "a95d67766ce8ab90a8fbdc18db1c2f6c47f85ece9a043a63445e559a2e78ff6f"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aea899b3efeeca96adfa7712258088dcf8896527e47bcd23019694c73662ff49" => :catalina
    sha256 "7ecd757f8758ee16ca66dc54a2cb439ee02803dba646462824ed5566968e770d" => :mojave
    sha256 "219e2389a530a12094bc94df9be02ef5c40f1f881b7c135700d151318e763428" => :high_sierra
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

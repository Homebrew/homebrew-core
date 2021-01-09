require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.22.2.tgz"
  sha256 "6884bcea1e452119aa85234ed55e013835b82b25a97ecb6d7084ec79bba49f22"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1ce49c40d0e88a86d24aecc38be5f1da86a5c112eb10447b89ff7e86ec0ebd6e" => :big_sur
    sha256 "62e2d83ad0da2232851f5cecbd730f626aba21bc88604a59d1179a3b938eb160" => :arm64_big_sur
    sha256 "8a0282cb9c1379f0d48961f70abd90614a7fc5672f95b883e38b94561e2d005f" => :catalina
    sha256 "af9ac90530a24d3b15acf7ccbfac2c8a97ebcd67791ba17d6a86ee281554f79c" => :mojave
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

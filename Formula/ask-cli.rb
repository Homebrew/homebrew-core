require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.11.tgz"
  sha256 "a2d9ddeb5d716f99447540fb6cc6db1ad2157ef8a1dbab4ce72c61ae0600e560"

  bottle do
    cellar :any_skip_relocation
    sha256 "de8d84401cacc1fba58698e856c8d2ffd68bd9953cb71f82dc0e790bb3955844" => :mojave
    sha256 "fa72668a41a5123ae34e466e4bd78e0d83897021fcd75a71800b21ac3b3bad63" => :high_sierra
    sha256 "bda4f90e0d45ae6ea05f61a45ba1f36351cbdff6fa9e1d018f5efb8d64d3789d" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
    system "#{bin}/ask", "lambda", "--help"
  end
end

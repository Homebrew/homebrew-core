require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.6.2.tgz"
  sha256 "ec11c540eec91f2585d1a49b38815a18fcb25434b19d177907fac6a3eb92aef9"

  bottle do
    sha256 "9bb7067c099611419117604cf794f70c408e21bf34c6042cd4329d839809aa56" => :mojave
    sha256 "32404fbc319de2cff7d0a840c430aaac52b93efcce537fcfd9738a1a4f99fc18" => :high_sierra
    sha256 "5bd294bbe830026a4a3a46e33e7a6934407cbdcbbf798163192983745cb8019c" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
  end
end

require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.4.1.tgz"
  sha256 "6521100da683326ada697b0e6240c49fc02e272e702226bd84a43fc6c544ec03"

  bottle do
    sha256 "91c1350fcb4040ff49030583107fd8ede5762d202024549c609c9a49d706aa85" => :mojave
    sha256 "280957dd55800a896a8315996c4e5572471aa30cc1e5bd7b8b35edf6df9532a5" => :high_sierra
    sha256 "37e48a253231738d42b2df71689285b682013b50b32254130dbea72a4f57cd97" => :sierra
    sha256 "fb964579b3f6a28671081bfeeb1c7d6f505f6db3a026b19f745c3f876d7054f1" => :el_capitan
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

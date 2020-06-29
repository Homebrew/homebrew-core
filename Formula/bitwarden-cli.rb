require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.11.0.tgz"
  sha256 "05b8e98100b4b09cbe9947b590f287c23096ba2aa1cc7ee471d707de951a8982"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6eade3b5cbd57f051c559f6e169a31185db2bf4b53f0822b5dcfa07cd6dd87b" => :catalina
    sha256 "8a3cf5a4be5a4adeab85862cba536f55ff79b0f85777b5b10006dd6cfd7ab12c" => :mojave
    sha256 "c52fe5a90c78f3c35cad4ecfd9ffeaba28b70ab78fb5fc48f280af569c113e80" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end

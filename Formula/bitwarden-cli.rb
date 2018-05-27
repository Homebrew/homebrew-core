require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.0.0.tgz"
  sha256 "75475a7eb9c728b0b16c1a69d397391019617cfbf73304bcc8724d9fd32aec47"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3e3c083b7f7ab541bd2b56f351caf9e5c6186203759f9cacd54098282b310f0" => :high_sierra
    sha256 "a28d684ce6f5a7eacfdd824acc4720e3907e6adf9ea28cbd0ebc18bfe9f0f499" => :sierra
    sha256 "46940d7d9bdeae078d0c63dbf713681b6f1129b2ed59a26bc51156c970624604" => :el_capitan
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

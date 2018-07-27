require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.1.0.tgz"
  sha256 "3b2ef5ff1db3cfb6f1632de007e5f2acf86092b9993e1d3af41b5fead302d636"

  bottle do
    cellar :any_skip_relocation
    sha256 "e73e401a9914b851478ef7d4ea1387b34fcd06840a3af14f9f2a2c99c4f464fc" => :high_sierra
    sha256 "8611407af8905b03cd993217a2075104cc95d21de424f9a909e1b0e06d7b8c9d" => :sierra
    sha256 "8c0cd9112b0700c9fc494280816ae6c91679454fb52855f01cf34ddc853e82e1" => :el_capitan
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

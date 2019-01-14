require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.7.0.tgz"
  sha256 "9b2325f41b6d412a6998563a7e92e49ee04e17bc2f543583b7c57249621e3f38"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e02e28a8c87ecca6c54cc57207c7edbb265de3f3f47915b53e3bb8051a1b5a0" => :mojave
    sha256 "eb6e15fcaceaa4ebf27acdd603bbbfb2e5f88c7d7e737e6ab68b61c562d60919" => :high_sierra
    sha256 "c771120f2514c55c0634ac10908d189bc5138c25446f0050d41c8d75a8695064" => :sierra
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

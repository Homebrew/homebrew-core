require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.21.0.tgz"
  sha256 "64fa1e8a01bf01d800dbebf868b399d80ba70060fd4b1d877b01f30ecdf6162e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80b4f63387acf25a7da830f20f8e1c64a82fd4285373997a9907df10136fa8ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80b4f63387acf25a7da830f20f8e1c64a82fd4285373997a9907df10136fa8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "54907b3055dba87d70e082a99cd3c3508327aaceb5b0266c48bbd0563f013eb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "54907b3055dba87d70e082a99cd3c3508327aaceb5b0266c48bbd0563f013eb0"
    sha256 cellar: :any_skip_relocation, catalina:       "54907b3055dba87d70e082a99cd3c3508327aaceb5b0266c48bbd0563f013eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b4f63387acf25a7da830f20f8e1c64a82fd4285373997a9907df10136fa8ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end

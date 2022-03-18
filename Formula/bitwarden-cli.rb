require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.22.0.tgz"
  sha256 "6c05e7d31d6c885d43aee8370bbb50691ea07ae379b818ff2c90ebdcbf9363ac"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356505be1123a39f3e013b0e44711e50ba6dd5ea9881d0bc0f1c5619ae1c0775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356505be1123a39f3e013b0e44711e50ba6dd5ea9881d0bc0f1c5619ae1c0775"
    sha256 cellar: :any_skip_relocation, monterey:       "689dfe0c3ceb82d45e6a11db4440d644f8079256e9304099ec55c7f1e5ab3626"
    sha256 cellar: :any_skip_relocation, big_sur:        "689dfe0c3ceb82d45e6a11db4440d644f8079256e9304099ec55c7f1e5ab3626"
    sha256 cellar: :any_skip_relocation, catalina:       "689dfe0c3ceb82d45e6a11db4440d644f8079256e9304099ec55c7f1e5ab3626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "356505be1123a39f3e013b0e44711e50ba6dd5ea9881d0bc0f1c5619ae1c0775"
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

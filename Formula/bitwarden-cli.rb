require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.19.1.tgz"
  sha256 "20b34a237dd9c93f7fc50e1e216894fc552c95727cdef3688879b83c4b24ffce"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "094d5bbca4585f192eb03e0afef59515557721bb0426adf8dba3a0535a978650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "094d5bbca4585f192eb03e0afef59515557721bb0426adf8dba3a0535a978650"
    sha256 cellar: :any_skip_relocation, monterey:       "05695bff9700f726e27f811849958f794342975bb51be58375d7a052be263555"
    sha256 cellar: :any_skip_relocation, big_sur:        "05695bff9700f726e27f811849958f794342975bb51be58375d7a052be263555"
    sha256 cellar: :any_skip_relocation, catalina:       "05695bff9700f726e27f811849958f794342975bb51be58375d7a052be263555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "094d5bbca4585f192eb03e0afef59515557721bb0426adf8dba3a0535a978650"
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

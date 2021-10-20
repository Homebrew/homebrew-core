require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.18.1.tgz"
  sha256 "60b3d75aa9ac7e624e40d05adf732ccf2a31f0e2678755de750b6cd7ae138ce3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23eba2bfa483bcc6a1b94cadb8e635bcfb2905bb32601eb12bf45b6a583e8298"
    sha256 cellar: :any_skip_relocation, big_sur:       "147a06ea8c66d129e89ae300ec1516be284ebe5ab5091a0146393ad6b3ee1ada"
    sha256 cellar: :any_skip_relocation, catalina:      "147a06ea8c66d129e89ae300ec1516be284ebe5ab5091a0146393ad6b3ee1ada"
    sha256 cellar: :any_skip_relocation, mojave:        "147a06ea8c66d129e89ae300ec1516be284ebe5ab5091a0146393ad6b3ee1ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23eba2bfa483bcc6a1b94cadb8e635bcfb2905bb32601eb12bf45b6a583e8298"
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

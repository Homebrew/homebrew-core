require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.15.0.tgz"
  sha256 "e9aa84a7b657356092bb811880d04f8a138ac4c0205d929a0d342d778136c058"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6be57a06586d40c1a935866fbe3ccf0f32c96a66d6142ba66fde9a4197cd4da"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d3b9502deef0e66d52f601b18dd23528c4121b0772f60050e5523b07fa4f0bd"
    sha256 cellar: :any_skip_relocation, catalina:      "532dd824a8c2e6c0c5b62bc9277d0a9de91cedcaaa8e376d003859ed74740b60"
    sha256 cellar: :any_skip_relocation, mojave:        "9bd3980b512626f33f9440173f7168ce2609b9af109b77c4f97c28dda06a166d"
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

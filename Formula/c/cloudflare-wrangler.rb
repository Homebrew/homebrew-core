class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.49.1.tgz"
  sha256 "a4d43071511ca0a498c9bec6d40240eb9626451f96775999fef4a956a048e5e1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f933f498a7f9ab10366de72154f373dc61063cf1cf021951f3c8ac5a42e0cc80"
    sha256 cellar: :any,                 arm64_sequoia: "0a03af85ebe22cbb6ad86838af078a8636473720fbab2333cc4a5cfb674aa68a"
    sha256 cellar: :any,                 arm64_sonoma:  "0a03af85ebe22cbb6ad86838af078a8636473720fbab2333cc4a5cfb674aa68a"
    sha256 cellar: :any,                 sonoma:        "ba09e13af9a77955dbe0219cd4b89f8808f0af34deb44763e752ac1a43df45e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d2cec3087048cb553cfe2d367c64e234c6f0d9642629c71727ced767807055d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8444a97bf574370e6e004ede2c4d712cc9dacc1d53f4e5c8c137f9c6fb9236a2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end

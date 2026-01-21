class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.59.3.tgz"
  sha256 "01235dd94b0e13cc7b056703b0c356bb12c34ca11ad9cd84e41c8585c3787c4e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d38dbd72da3612acfde384caf577577e6b6d7bea14448bdccab16b0426cf09fe"
    sha256 cellar: :any,                 arm64_sequoia: "eb2ce3a82fd61b6eee1088c094090fdd439115e54c00a1586d0cc74027d98eae"
    sha256 cellar: :any,                 arm64_sonoma:  "eb2ce3a82fd61b6eee1088c094090fdd439115e54c00a1586d0cc74027d98eae"
    sha256 cellar: :any,                 sonoma:        "e0ae85821d7b33d8b1ba847c633307a22e60a18c2312f6756ef4713f9844620c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ff52cad25652ee3cbdc7a75f5d04c8ba374a52b4901d5672f1675a5e1a96081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0185e17e755680c2839b734e7753d0868098d59b9eec43940e510c31b69adfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end

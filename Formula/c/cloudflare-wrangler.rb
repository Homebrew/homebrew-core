class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.81.1.tgz"
  sha256 "94cd9bbb2972a85368bfc272f4e7ceda578158d46338bfcc4c2b9870a61727c2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a184864c11fd0286a32641e6adbf2fe967ff76762737b3457d7e05b5c68e78be"
    sha256 cellar: :any,                 arm64_sequoia: "1f421b3cc9212f2a7a5e879aeb81a031d3435d6489d3c606bb7a3ae142178376"
    sha256 cellar: :any,                 arm64_sonoma:  "1f421b3cc9212f2a7a5e879aeb81a031d3435d6489d3c606bb7a3ae142178376"
    sha256 cellar: :any,                 sonoma:        "ae1ea71baf5c0dc64e670fc1ece2aa65376f5829c687da5db0764e50c2ac71fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb1fe13811bba94998b6c12da0b93b18e3cc1fbc758249fb802c01c5e71413f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f975a911dd0985eefd181ccd83bcaeb2b60ea4c1922b7a856a2afe53b296d01"
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

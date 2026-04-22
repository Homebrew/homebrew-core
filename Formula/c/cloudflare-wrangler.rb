class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.84.0.tgz"
  sha256 "3539e9de32c5da48e62c470c0fbf3655bc3e837823c66ba80ba09f2a535e9fd3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1eab875f220998de7739402c1939f5154b3b5f61432eb83fcde02e4460914ae"
    sha256 cellar: :any,                 arm64_sequoia: "23be8a974ae84e42a2364ec9f2de774fd483cb9f927ec16e60d620eebba641a1"
    sha256 cellar: :any,                 arm64_sonoma:  "23be8a974ae84e42a2364ec9f2de774fd483cb9f927ec16e60d620eebba641a1"
    sha256 cellar: :any,                 sonoma:        "02eba6e68b33478552556837de01bad4655e960905123bac236000079cb58ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "244850b17216379579bd4a4226bd4ff86cb40c1dcea2f0e81c6ee232362f120f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6aa1b919f247413d2144dee04fbab3c22a44a9e624959f2593cb9cc94ccd9d9"
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

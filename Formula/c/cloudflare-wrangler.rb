class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.37.1.tgz"
  sha256 "624275cb547887f5d809eb69092dc03bc8f19b6d3a6e1f296e6edd1f47843a05"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84bfba770f3b547225c086d7d00cea1a2aa25a47e5a2686d5b6cdeda14f84973"
    sha256 cellar: :any,                 arm64_sequoia: "bc741891f834c00e4f14c7342ee62fb00e2f58af3c4e9c785a55725c403fe6cf"
    sha256 cellar: :any,                 arm64_sonoma:  "bc741891f834c00e4f14c7342ee62fb00e2f58af3c4e9c785a55725c403fe6cf"
    sha256 cellar: :any,                 sonoma:        "b34152aec10e2b12da49f8d4421c8bf6220e5f76356592667bb221df872e5cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39c964dadbb780a10b83bc32b2006279e1424f91aacebc54bf4ac1d2e74d79c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a15fd4eed97832a50f5a762371effe36b5676cdbd437ee79e104bea614ee5e3d"
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

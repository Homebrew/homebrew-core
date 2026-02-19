class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.66.0.tgz"
  sha256 "7abbf619b132786321ead2a48b5156173d122c295c8c6895bf1997467d6e3554"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4061e1d6a08a3d8f58f8a46cda26620f827fbb73137ff9f043c453af8de53208"
    sha256 cellar: :any,                 arm64_sequoia: "6e52521bfc4a0ff2b48446ae9a03b3309dd6eb39204accedfb7d6d233572e7aa"
    sha256 cellar: :any,                 arm64_sonoma:  "6e52521bfc4a0ff2b48446ae9a03b3309dd6eb39204accedfb7d6d233572e7aa"
    sha256 cellar: :any,                 sonoma:        "915481bf27059272186d81b32938a7e8c621377fee56d634619b7e30daf3bf7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9678641072dcd7d482971e3de713d56ab3f9aa1b733c68eb72270e5864ef0dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e363980ba21a6aeb5044e01cdd992960db78b69368de3f5919c875ce7420895b"
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

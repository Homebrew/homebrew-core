class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.157.0.tgz"
  sha256 "0a7a5436348af18342828be106f8e55ef3aac0ecc539f52a7999a5a500630410"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "df04940f7fad353e14d1d7a475743698d56ec3fbcb1e0908ca08509c6b0135e3"
    sha256 cellar: :any, arm64_tahoe:       "df04940f7fad353e14d1d7a475743698d56ec3fbcb1e0908ca08509c6b0135e3"
    sha256 cellar: :any, arm64_sequoia:     "df04940f7fad353e14d1d7a475743698d56ec3fbcb1e0908ca08509c6b0135e3"
    sha256 cellar: :any, arm64_linux:       "2b356383c0dcbb0e1f8697a2dbbfd49eb4438bbf4d2089c753ee7a38e2278cb3"
    sha256 cellar: :any, x86_64_linux:      "afab411d1815b585405e4920df11bea1ee9dbb155014a955e41aed409ca36d4c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end

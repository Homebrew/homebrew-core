class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.135.0.tgz"
  sha256 "4903b32fe43dc9d3de0deb3232d93275b993091e174a42ed0489fa157ac64306"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7be94c0b418e363cdc3e5fa60322d0e7f3c80e1fd5e6edcf742d94aef4ab66a1"
    sha256 cellar: :any, arm64_tahoe:       "7be94c0b418e363cdc3e5fa60322d0e7f3c80e1fd5e6edcf742d94aef4ab66a1"
    sha256 cellar: :any, arm64_sequoia:     "7be94c0b418e363cdc3e5fa60322d0e7f3c80e1fd5e6edcf742d94aef4ab66a1"
    sha256 cellar: :any, arm64_linux:       "41d97301076eca990199dd6d0490f991f2460621159c248098a44f3be0c87ed2"
    sha256 cellar: :any, x86_64_linux:      "e749b43f72a30d2454e29e9fe4f19b50953915a2fe22ae352d0d1a16455799cf"
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

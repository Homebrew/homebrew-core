class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.156.2.tgz"
  sha256 "c68cd421588d181e0cad3ee393cdb0f0e4d5a96d0322a4b200890d7aef00cf4e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c26bacc79312a8204b7a8827a40a498513fe0e7cc1c97ca41f369b0d885c87e8"
    sha256 cellar: :any, arm64_tahoe:       "c26bacc79312a8204b7a8827a40a498513fe0e7cc1c97ca41f369b0d885c87e8"
    sha256 cellar: :any, arm64_sequoia:     "c26bacc79312a8204b7a8827a40a498513fe0e7cc1c97ca41f369b0d885c87e8"
    sha256 cellar: :any, arm64_linux:       "f672d413cb6544f2b35c6c4a15bc18698d7c9b62b75f5a89776eb7b9a127f7e9"
    sha256 cellar: :any, x86_64_linux:      "39f9fd02021fb405393d5786059dad93c05798c5d635bd8d31076c0580bef5b0"
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

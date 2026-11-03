class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.156.1.tgz"
  sha256 "8e45df33c890c8ff14a7165bcfb46df149cd868014da94fec0aa9d318f0ca2e5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "adb9ac9d24292780538f8a40de30fc514a44061363a1ad9d207c31f98b22132c"
    sha256 cellar: :any, arm64_tahoe:       "adb9ac9d24292780538f8a40de30fc514a44061363a1ad9d207c31f98b22132c"
    sha256 cellar: :any, arm64_sequoia:     "adb9ac9d24292780538f8a40de30fc514a44061363a1ad9d207c31f98b22132c"
    sha256 cellar: :any, arm64_linux:       "a2e0bb7db8fa1b5142202a5325ce0b43ff5fc2d2bf98dcb5e3b3c03d57a91894"
    sha256 cellar: :any, x86_64_linux:      "683bad0dd4343cc8c155a1d7e11d56324e63502e00e035a4af73c40c68ee9d55"
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

class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.85.0.tgz"
  sha256 "2ccf373d72356991a246880b8c4bb7ff42beae1fc329d81b962db5bd79bcc3ef"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e10bfcde079001066b07316da7322605fc384d4e1827a9cf35107f068cb2f07"
    sha256 cellar: :any,                 arm64_sequoia: "d60a68229ed977f4a1c0ef4ec20f2645bd27f22aa1fd3841faced23d20744a97"
    sha256 cellar: :any,                 arm64_sonoma:  "d60a68229ed977f4a1c0ef4ec20f2645bd27f22aa1fd3841faced23d20744a97"
    sha256 cellar: :any,                 sonoma:        "dc311ebcbdb22efea43d3ab7b8bd970c0e5682050b50c41e9b55718b18be0b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ef5326f96c99d47d5f5451a60d729cca833617ec86fa35dcccaef66440a8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45b7ee3b6f19a8295b209bd4e41db5a38c29bb9c181e1ef8367c573e2f86c27"
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

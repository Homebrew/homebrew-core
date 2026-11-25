class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.168.0.tgz"
  sha256 "ce779983638627326c9e6981eab0795d004eb435dfdaed96dcd9368d1be87335"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "9d174614580d7f1b9dd4dba2efa4ddd1088fe17f9d049b2d7daaea4964c6d0db"
    sha256 cellar: :any, arm64_golden_gate: "acc30272556496eece469f7537a153e99610e4abc08f853d5e84ad398d09d0a2"
    sha256 cellar: :any, arm64_tahoe:       "acc30272556496eece469f7537a153e99610e4abc08f853d5e84ad398d09d0a2"
    sha256 cellar: :any, arm64_sequoia:     "acc30272556496eece469f7537a153e99610e4abc08f853d5e84ad398d09d0a2"
    sha256 cellar: :any, arm64_linux:       "598d3cdebd93b7557e8b43b6df6b94b8cd1af25f0d1870ebb5402f2295d85c2b"
    sha256 cellar: :any, x86_64_linux:      "475ba9659471da8359d7550f100e814b166d917e2f857d2f2fe714cd4cf75b84"
  end

  depends_on "node"

  allow_network_access! :build

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

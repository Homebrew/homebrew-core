class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.162.0.tgz"
  sha256 "bdc0366417fbeea506296931be1c5dd91c131043f8873e31601e03ed4c31956a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "31d88a0441717b2ae02fc14fe20b78989112167bb7fcffbd98dea4da0c2c8034"
    sha256 cellar: :any, arm64_tahoe:       "31d88a0441717b2ae02fc14fe20b78989112167bb7fcffbd98dea4da0c2c8034"
    sha256 cellar: :any, arm64_sequoia:     "31d88a0441717b2ae02fc14fe20b78989112167bb7fcffbd98dea4da0c2c8034"
    sha256 cellar: :any, arm64_linux:       "d2253503c6c8375c3db0fed95626b7a05dee1e2037ddc508878bb43902f20c97"
    sha256 cellar: :any, x86_64_linux:      "adc3df6d67279a7f29f8747fbfc7833dc2b83a1c42638a97f278e2b4c8b20c81"
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

class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.166.0.tgz"
  sha256 "3333bd0b9491c76c2717582f69cb0d1ab2dab1c014e86aa859bc3ce04fa91d40"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "2ce5472ac01b32262a7439e17065555476d9c80340041c39d5086d42ed50eaf6"
    sha256 cellar: :any, arm64_golden_gate: "5746b8894f607510944c3c30f12a1f21b1d8281c0b48a24502566c49d13a2062"
    sha256 cellar: :any, arm64_tahoe:       "5746b8894f607510944c3c30f12a1f21b1d8281c0b48a24502566c49d13a2062"
    sha256 cellar: :any, arm64_sequoia:     "5746b8894f607510944c3c30f12a1f21b1d8281c0b48a24502566c49d13a2062"
    sha256 cellar: :any, arm64_linux:       "5c04f1966d54a679e4a657e9424739cd95beab74f68a48d20eb5ade4ce2920ff"
    sha256 cellar: :any, x86_64_linux:      "26ef5058643a37efede2cd251575c2e8b667350004645f491e41be93041147f7"
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

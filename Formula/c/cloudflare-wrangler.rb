class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.98.0.tgz"
  sha256 "21c6897c008d8c9a135a31e6271b435ba69edfbbc9fba1875ce34d2aff933248"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5e6d386fdfc698220b58171bd159d6c77ed0d187efec0159ed57044837b11f32"
    sha256 cellar: :any, arm64_sequoia: "f83c0f27765432ea93c4ac59cdcdc987dda9791dc32487e30b6ddafafeaad873"
    sha256 cellar: :any, arm64_sonoma:  "f83c0f27765432ea93c4ac59cdcdc987dda9791dc32487e30b6ddafafeaad873"
    sha256 cellar: :any, sonoma:        "b604163639af1fc6fd79fb0b78b88958f638b25874ac484a892bc708b0a5a287"
    sha256 cellar: :any, arm64_linux:   "039adb62038ed098f0c4c2bbdae1fb1188c1e3e01e1be22a04af5581b57fecde"
    sha256 cellar: :any, x86_64_linux:  "1de8ff48f7de17e3d3a2b430d6f6495fafc626e23132489d7904061ba7f7fa7a"
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

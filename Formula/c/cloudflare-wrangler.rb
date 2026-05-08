class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.88.0.tgz"
  sha256 "4739fead0fdd95ef3c60f18721fd43b29a289729970edc387fa2521c29dd3fbe"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ce7a33acf65be2af37fa979d914cf5dc822be56e517c70957ab76f11bfbc750"
    sha256 cellar: :any,                 arm64_sequoia: "6fc8e3b0f8d31b059bf8d792392b511474aeae4ea4b9dc6582189b8bda9fa606"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc8e3b0f8d31b059bf8d792392b511474aeae4ea4b9dc6582189b8bda9fa606"
    sha256 cellar: :any,                 sonoma:        "9c1d9d1c512f77edf9fcb70575cd48c3eb3d641c04262e278fdce17bd22ee155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13af6b9fcc21633d4dbb9c632579556c6e9b9eb04e882473c6ee127eb3a76cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c35607e09cdc789a7523649b9997b393b42b1f8382d2adaf6d944bd02fe0d02"
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

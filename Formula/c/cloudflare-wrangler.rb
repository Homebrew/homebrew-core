class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.125.0.tgz"
  sha256 "fe933c7ccabaf41e7af305138f1de9fd2bfb1e084c7e2fd50ba3d0ca77a44502"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f646267b5fe0b579b0014dff9f235263a53bd09d066f7a78acf71cda4e8177a"
    sha256 cellar: :any, arm64_sequoia: "7f646267b5fe0b579b0014dff9f235263a53bd09d066f7a78acf71cda4e8177a"
    sha256 cellar: :any, arm64_sonoma:  "7f646267b5fe0b579b0014dff9f235263a53bd09d066f7a78acf71cda4e8177a"
    sha256 cellar: :any, sonoma:        "d18a14a1883a7678ca1b1fa1cdefe09cd02f64a405db9a2dc4fb581ba75d5eae"
    sha256 cellar: :any, arm64_linux:   "caef478719f2c9791495ad4b828f500a94ed27267ea57567e5fb227e984f7f4c"
    sha256 cellar: :any, x86_64_linux:  "646095033cf8318f662786b94ba45854cdb7f61962c8cdf64c58b46cd7a65f17"
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

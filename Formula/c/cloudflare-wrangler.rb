class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.107.1.tgz"
  sha256 "dba98cccb3345a83d0ad08c621d5df1fde53578e36092e9d202f1f309d477744"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "16f0f3b0384fdb60a75b249ce59006bf3fe827c95decdcd8ec538def7ea543fd"
    sha256 cellar: :any, arm64_sequoia: "7e951bc58be5e5188487e96d9fc95d3a6a69a9d37b8039a404de2ebe24e6f0b8"
    sha256 cellar: :any, arm64_sonoma:  "7e951bc58be5e5188487e96d9fc95d3a6a69a9d37b8039a404de2ebe24e6f0b8"
    sha256 cellar: :any, sonoma:        "62447ab3d17673488692938d48a2a6b728979747e3ad8aea7dca7ba86457f319"
    sha256 cellar: :any, arm64_linux:   "cc5a5cc254a11a3e03946719eec0b3313c1df0c875a09bcb0643b2c93fae8198"
    sha256 cellar: :any, x86_64_linux:  "017f3e2159a920f73d884857b05e33ec5c4b09c6914b8cfcff0ff6ebe5bdf6cc"
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

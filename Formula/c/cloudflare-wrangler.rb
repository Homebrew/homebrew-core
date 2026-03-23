class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.76.0.tgz"
  sha256 "75a19def794e1ae4d59a2600b11b3f345dabd3205600c550faaa18196cfb339c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e638d2e5442dd184e94db3f8793a76ed4fbdd04c4215496ec131ce3f31411fab"
    sha256 cellar: :any,                 arm64_sequoia: "e7f18372311c291a72711adb52cd4601a6251fe1722fc5de857d0ed8a59791b0"
    sha256 cellar: :any,                 arm64_sonoma:  "e7f18372311c291a72711adb52cd4601a6251fe1722fc5de857d0ed8a59791b0"
    sha256 cellar: :any,                 sonoma:        "d168270f01c41d7d9dcf06597ae3f4d134bfe425344a9cb9edb35717329f92e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2454d523a6266b3db43331d78a26d15807a4b9a185597f66cffa2d42b1dc3c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4acc2ebbc347a0013f3487ac3767ea69e497f6974c3e83f19ea6142ae142e065"
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

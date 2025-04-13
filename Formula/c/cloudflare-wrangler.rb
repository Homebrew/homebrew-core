class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.10.0.tgz"
  sha256 "e3d29fcc6dc102d098d95b5f5e3de5c27e9ceb5f46b4d7d174ca49572fd9f827"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e38b35f3b9e9dad155e5451f8eb83a98f74ccb319bcaf99f863693c04b94e976"
    sha256 cellar: :any,                 arm64_sonoma:  "e38b35f3b9e9dad155e5451f8eb83a98f74ccb319bcaf99f863693c04b94e976"
    sha256 cellar: :any,                 arm64_ventura: "e38b35f3b9e9dad155e5451f8eb83a98f74ccb319bcaf99f863693c04b94e976"
    sha256                               sonoma:        "3591b87b8255e73786f7e51f712beb6f83a314116b97134a011ca162e4ef50ac"
    sha256                               ventura:       "3591b87b8255e73786f7e51f712beb6f83a314116b97134a011ca162e4ef50ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e353e44790209da659effa8fafa4e369e3d5769fe94251afc1beec980f4698b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d9344bd3c4ec5682422e2426bae1901c1d7d953157092db169774c4f0a13ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end

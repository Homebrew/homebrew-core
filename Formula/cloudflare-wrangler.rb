class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.20.0.tar.gz"
  sha256 "ca6829372d471cc7155fe02a600e92afb1fdf0a4847c65b91aedb99119ef398a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84b69516bbe150fef52a9dd20619008dcb80572ccea80412013e4054fa9a594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad4f239eee085f4aa2dfd7fccf64bf64446a25cd661d6e9593567d67f48c3a80"
    sha256 cellar: :any_skip_relocation, monterey:       "dabdde3faa724209d1100f35191bedcc6b1c4e091c0936d64aff45317dcc50f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "63e222a03ab1f63317ad25a57f2a1c8c30d0f6c5c015fe7408f87f3305cc16b3"
    sha256 cellar: :any_skip_relocation, catalina:       "d3107d9cbfee644078a2d0254ae96d9716d202a0cb08f7200f5d416fcdfaf3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c40cdcd3ed3657dfc7faddbe5f7fc5486e3b3dc5883272a4f3e643c5f0a78cf2"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end

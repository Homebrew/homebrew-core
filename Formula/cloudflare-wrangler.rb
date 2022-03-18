class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.9.tar.gz"
  sha256 "5320dec5bfd587dab11306511c50c4f7e4a8cadfdf2fba2b360e44e9bc764c90"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88444eaf4e8d000cc7668c0cb3c1f2220bebe2d9c8433ebc7553621381fbdb6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49786bbdb195e4d0a8ed3060b4b74db5466142be1d16bda0cd0752a59163d11e"
    sha256 cellar: :any_skip_relocation, monterey:       "8425e354c171efddb99785c1a70ba6802908d0199193ed120f5edcee9788e3e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "af0a091809c8810abe69d9fdb3fc48567af432aab791530c016aeac7e4c8a861"
    sha256 cellar: :any_skip_relocation, catalina:       "afda98171e77ddf16548843cbe6f6a34e8c06a4c70edb169de0640ee05584c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3795f291dc7dc8db6a56432449d6298c7aec3e295361a46c1a61757348bba462"
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

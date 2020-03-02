class CloudflareWrangler < Formula
  desc "Wrangler is a CLI tool designed for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/tooling/wrangler/"
  url "https://github.com/cloudflare/wrangler/archive/v1.8.0.tar.gz"
  sha256 "ebb31c2549733991823f965025da493bbc2a1644d02668549700793a29df0229"
  head "https://github.com/cloudflare/wrangler.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/wrangler", "--help"
    assert_match "wrangler " + version.to_s, shell_output("#{bin}/wrangler -V").chomp
  end
end

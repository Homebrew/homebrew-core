class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.13.0.tar.gz"
  sha256 "078ca2e7941f6476c18594fa7e7d26da35dfae2b65557d3ad6d598844cf915b4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    cellar :any_skip_relocation
    sha256 "204fcffdf240bd56163b9566680e2966ba56aaf2d6ebda9189f92e106a3c85f3" => :big_sur
    sha256 "c49e743e5cd86844ead5b202dfa826151b3432d3cdb9b9d8bdd898a54081d939" => :arm64_big_sur
    sha256 "dc78dcffc04845809392da83c962a30f002675cbe9f126ef0bc4e5c2c544e9de" => :catalina
    sha256 "64b4d6e3303f79e8826b194499726fb8647a1ac37544ae05b2e278172f161777" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match /Code 9109: (?:Invalid access token|Max auth failures reached)/, output
  end
end

class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.11.tar.gz"
  sha256 "55fd07190523d03e9a8bc5509e3aee21852979e2833f9d73c4c7f7d9f82d8724"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9303d4d1affe68788231a3b5a666f8012cb7a5ffd3ee45f28ec6afa042e6ae91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e721f9691be4d5f7073415e4268c0dabee4ad69268b146c17817b2c455836814"
    sha256 cellar: :any_skip_relocation, monterey:       "e415c7b043184724fdd801644e3c4818e5a87800cc72fc903efaedb9270abfac"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a7ffa18ffdd625af922e2c1107f6acd91394ab214e532eabe7a312bad68bf97"
    sha256 cellar: :any_skip_relocation, catalina:       "cc2d5c18f10add11051f523bb0b9f470fa31cee268f3261cdb359c8b373a67bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02772057edb9c22e089c3947fe5710015edf4297e4c4ae11dce9d95e66a2abf"
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

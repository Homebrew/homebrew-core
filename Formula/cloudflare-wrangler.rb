class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.7.tar.gz"
  sha256 "97e982d4230e5de9d8e6d8f6f20c0deceb40780fce7371ff87634cf41126026f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c5767560504cc933abec073c1ef599168d3705c29a861b005d42751ceb58a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bf49b8f1aa0d3287c8c6e179d441fe564864eb3ca6512c1d7e80d38ad265544"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2bac996d754ee72cc4dd94c837c01486762fb3a2f83a0d87da809c03ee9668"
    sha256 cellar: :any_skip_relocation, big_sur:        "a481f7f6a94d74c218fea866ce5af7a34306c9251f7304460d8e0ce8c4189cff"
    sha256 cellar: :any_skip_relocation, catalina:       "cce41ed653c0ca83ee0fe92e764c15dec274e1451776c1ad1b18cbed1cd23e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e9869c3cc31d60fa364689efc084debbccdbc9ad6f6d14c1b76b82ab243828"
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

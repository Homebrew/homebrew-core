class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.20.0.tar.gz"
  sha256 "ca6829372d471cc7155fe02a600e92afb1fdf0a4847c65b91aedb99119ef398a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fc9e1228716d8eda62a4919dc70ba86a71d57930b9ca9114aa8bff56da85e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "770767175d90b1b0ce0efba7e0ed89a9455a1c3b7597a2121215175fc7d40918"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a6bb4463361a162f236e8d7f7714e643ea5318928ada6b527ceefdcd8eb435d"
    sha256 cellar: :any_skip_relocation, ventura:        "aa09cdd4b0bb93ec8ab3171074f61c57311b431654c6312b580de4a4efb0a6c7"
    sha256 cellar: :any_skip_relocation, monterey:       "fb5ee30ee2c08e317bf17a36e2219bd06a9be8ce41551a769e64c6d79ea8d7cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e7fd0bf436fc73ecf82a3575500b5dd37a2d1efc549762767a9899a7824f576"
    sha256 cellar: :any_skip_relocation, catalina:       "56e6d54716315c45b5198782c5f00b95fc9a9a99b36dbba1a06cb3b7c9c819d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89909585925717cb4e0e97532da21898d3cc027ae9ab1e14dd56225cb72e3a8a"
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

class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.13.tar.gz"
  sha256 "0c9f792baecb0a2314cb3153dcc608ac1245db6845cecf51fbc08fff120b51c9"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed11f90f43a9bc83cfc4fb55ac9efb3207cfbc05bd889cb9d3495c5649b2f311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "106efad83d98a6d71cb4865d9707f92a184a61a5025960f83486cdc06097d0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdbb59ec6ae9c0b4c3b00ea2981a3fa878fc042ddf7a2e5ad9a9ff8acbad5c92"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8b9608b6cc58cc5716353b473d21e7cc03d4f5fa2b510cfdadae8f53ecd694"
    sha256 cellar: :any_skip_relocation, monterey:       "fba749faa84e2bc969d5ec4bce6242469626a1e1080f50154f7321ff508e74f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd1b017881401199cfef02bf375be1188b7861941baa329ece33a53222a090db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9cc761744ea96b4688bb5881fbae62e226fc5c8e0e691871a9bc562b3d50de3"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end

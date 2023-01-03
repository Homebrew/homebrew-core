class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "b7ebda48bdee6fe78ef5eb694cf03e3339ceb94253bf026fc23d18005bc450d2"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9287845a84154c37e340c235d0353e83b07aeccd747a6c4c70f2d56f4b0c65a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834b4bec3e6dc42fee3350003617115a605a91ea15ca38bec6f032b0a9b7cf0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29e1750487014b122fa53b55d621fc319f4691a5aa31b36062189481433ebb04"
    sha256 cellar: :any_skip_relocation, ventura:        "aee40cac20f937dc5ce3df0e7c1d4631355a5842e57168df4a869f2bd364f256"
    sha256 cellar: :any_skip_relocation, monterey:       "6412113b172828be5ea66f985ad02e7cf9bf0d673e84624a86fe64dbfa1218c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "60593abc94cbd7a034e5831cb17d61404f394e8ca3a66d727e08c56906e5ab4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "909d9ddd40c9868f3ff51189ec695bde8344e50c0041b0a51d0709861433cbed"
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

class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/v11.2.0.tar.gz"
  sha256 "9c33dc1597a9014e39af0f37006c97dbb8d0340476e451e7be7d7b48ac4df8aa"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8b5ad94ce660e621a11f02defaea098f114661f649c4c110ad3c5d8cfd9b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f08adf169c70023b9a27284ca9fabf313ea162b0a476663d7e08808365edef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "301cdcbd481d65057ba133b983699857d78cd069bb4adc751f59013d4ced0941"
    sha256 cellar: :any_skip_relocation, ventura:        "ceace0c8b7d85fe71894499adf325d4474bc2a0e011c34c2902578d61dc8712f"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e3c2574c9a45f398d9cdd8be93954a9ab37fd3aad9a3f82d13361f56c030a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "309c17cd1a9b485862502436ad1d3c2991a685d2293a1ff92ab57613bc1246bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13f8b5f28ccd014f5f76ad56471d8f7fd0c1cb55112a563f2297fff3852e900a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

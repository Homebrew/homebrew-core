class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/v11.0.0.tar.gz"
  sha256 "bccbeb1e960349a6ad8d7c8e9d2b82129702131acc54063e350831f055b96cbc"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d949f23b9c03e92f1b3baf2fb713d0428d872419a0134f95013a26f352469a1"
    sha256 cellar: :any,                 arm64_monterey: "94f0798a7f11f336b733e105e8c2923a57d6a72a90d0d928c33a8aa4b2b3451b"
    sha256 cellar: :any,                 arm64_big_sur:  "c5e233b00b1e433d2f9d944d1e143a44bdda8f32b5e62f1052510357ddab7380"
    sha256 cellar: :any,                 ventura:        "05f2d34e7f2a607f59a7f0c67f643758397214d767dd34d15d13b44f091ed379"
    sha256 cellar: :any,                 monterey:       "94df29b5932d9305fae7a5cff9d0f94b45b1e759934834282a37e482f37e1822"
    sha256 cellar: :any,                 big_sur:        "f9e27f23bf2af9c377a54661050e2aceba15b568e3d38603e82519840aed1fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f0def49e4be7cd9b27d2e3ad96a475dc520673fc0ee31cdfceb41869507a5d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

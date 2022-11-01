class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v10.1.0.tar.gz"
  sha256 "7d5f7c07d724dbc3caec4aa027356231af2d30ffc82f2d523ddd8fa9545022a6"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dcf1b32f32beec9dcbf7fe7f3b5907bd30cb19e096bc48f0d8df82146be4c6f6"
    sha256 cellar: :any,                 arm64_big_sur:  "d387b9d83b94ee9d96bf6a91c9b2796c4f9ada5bebbffef413e4600f67bd9d78"
    sha256 cellar: :any,                 monterey:       "caa747cb89b7ac3934911873a3cda1b2a224e9069c63c4ce1b8c238c1cc5ba63"
    sha256 cellar: :any,                 big_sur:        "7f836af79b87200c8f84ba086cd2ba7cf0e4e33ccbe15de6ed1f972e187820cd"
    sha256 cellar: :any,                 catalina:       "aebf734a3cb9253930d5ea3c088a61f8b3a53b3fd789fc8fab73e9b2074c5372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f637b1aa99e1ec2e4e4d382189363893e6b618ec7d514b57ccd231b6b7c648"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

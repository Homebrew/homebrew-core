class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v9.0.1.tar.gz"
  sha256 "45ea15e617c209fffbbff90d90f55237cd15d62a4600d1bf86c87693fb973702"
  license "MIT"
  revision 1
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15b72ee71268c9156d221265d509c07feb99f45646a56b6784fce43c5eb0f3d1"
    sha256 cellar: :any,                 arm64_big_sur:  "8a642b6a8fc800a7c220bec7001fec71f49e0050c75b5be631d9b3a760e84585"
    sha256 cellar: :any,                 monterey:       "ee82d1076f4b0a898f4b0a63f8f9d605a96baaf24dde831082c18d913bcfcc47"
    sha256 cellar: :any,                 big_sur:        "85e62c97f2ac55cbcc143442303e96c021ac33056ea2fa8c2e54cf072af14e1d"
    sha256 cellar: :any,                 catalina:       "2c2222981454971ff56a14f856a0a6cafdcb974a42191314d6ec8aac9802c198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c0c392024003dc26a03dbaf1ed2a5d562fbcf27a760119119b73b1107962c1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

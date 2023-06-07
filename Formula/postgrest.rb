class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/v11.1.0.tar.gz"
  sha256 "47cfeea8d64e2fc0c08bb741d83bddede0679ea7bcb91073b5eb515c8de6e363"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d86b346e846d864f45c465020465a7c24456878ca14bf5b3d1d7a9d80f56a0a0"
    sha256 cellar: :any,                 arm64_monterey: "399922e197a9a49ad6b30d94a66b8c8915814f07741b39c1dedc1644cd48b83a"
    sha256 cellar: :any,                 arm64_big_sur:  "653675a6b067792b17688186fd948d5bac5bc21da88a8abfc46d8f7931280bbe"
    sha256 cellar: :any,                 ventura:        "b47ebc8fa96d359d1030ed490e2538ce8ec2c2a23eaa44710e6622168c9df1b1"
    sha256 cellar: :any,                 monterey:       "40a33b088db1e419bcb6e8419d714f451922c61c5bda66cf8813d34c57b289d7"
    sha256 cellar: :any,                 big_sur:        "d5249b83d94742a01b4fda1a173365974b8fe243e06706d0e71f1fd1f3db2c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a4d42c63c55b35f30926973ee4573c7d54b4b384791e13f2a937448f7fbf7c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

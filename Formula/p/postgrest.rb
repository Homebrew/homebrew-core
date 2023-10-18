class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/v11.2.1.tar.gz"
  sha256 "7f1dcd0a8e92363ea51504b21cf59860850a882e91607329066f21ccd9ec30e8"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65b1abaa8da850a5a7937b60619bde1a70aed838c67cb9c10aff1ec3696c1025"
    sha256 cellar: :any,                 arm64_monterey: "0be15ca6bd357a48c80d4768a775084b5450d08d9e79ad256a8515cb3e2cdda3"
    sha256 cellar: :any,                 ventura:        "a2213bb791e07aba4a50f2fccf2402329d048697ea335e3cbe9506ab4c78c9f7"
    sha256 cellar: :any,                 monterey:       "d8d7f8ecae1534a5c0ea2a9e4462897f172c8bfa5ba672420907386e36a22ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ac2e26d621e8a7eb623061ca9c119a0b9d0e58e9cc57fcd58fc52210755269"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "An error ocurred when trying to query database settings", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end

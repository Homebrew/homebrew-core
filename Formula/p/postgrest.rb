class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.0.2.tar.gz"
  sha256 "154588d2c0c35b0906c8e8f0f9672cb95f93eec771d9636a2bff17ac6cd8f974"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3348113f9d24ad034979378e9050605b436f32f200b2d78bd9afea9ec5aa266"
    sha256 cellar: :any,                 arm64_ventura:  "91f5d7ba31659e4fd6947a15849c539ce4e14b6f08c9e4ce71d062a22dd5b044"
    sha256 cellar: :any,                 arm64_monterey: "bd89cac5e1ca88c17dd721ae1774ed5ae0b0f63e45b078baa8684b64b533b3f1"
    sha256 cellar: :any,                 sonoma:         "5803999c9c4a3b70d535ade2c2af9c3ae15d308706e2ce562f66244ace2d0022"
    sha256 cellar: :any,                 ventura:        "a50150eccaf453ef8a7ae47fb16a15daac839896d0e4ae260ab48863d7c2b436"
    sha256 cellar: :any,                 monterey:       "74db9ef364a03942b96ab728250523c9473b32d6bdc07fcbfae53372067ee495"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafee5d08508e19781676c41f52b2239320de4d7a96686d9ac224931de0c636e"
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

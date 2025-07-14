class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v13.0.4.tar.gz"
  sha256 "515ea77c049ef69f4553940ef0f13018dc2b72792195ec11a2020fe8914ceab9"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0dd01a0cc4249c3ac70018a53267543cde8f8436541bda7f0d186ed64bf9884c"
    sha256 cellar: :any,                 arm64_sonoma:  "3cfa32fe2d94aeff85ccd56cd3cec21c127b77d88db7f397e4901da3033eb138"
    sha256 cellar: :any,                 arm64_ventura: "23b47b1ae739206477cd1f8fd0c22c57b0753af621d29952f039710db0044fbd"
    sha256 cellar: :any,                 sonoma:        "1f4f9ed02529176f02fd489905dd72c5fc7d81a792ffe8742a8aa6222e395021"
    sha256 cellar: :any,                 ventura:       "c0adc9b0b3dfb78e3aa82e400f64b8988967792251bcc789c7158b0de4dd101a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02951c7486b6b57bc5bca36501e060088cacd70e216d04e9855a946c2802d724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c1e10ef5ba17d7650608e26e743094262fd0e2d3f3b45a7b13e5472089b717"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https://github.com/protolude/protolude/issues/149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end

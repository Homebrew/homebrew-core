class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.14.tar.gz"
  sha256 "76dc4291759cee9397fc2e88534d2e6cf6bbeda43819ea2eb38c771983c59054"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d2f240df7bfcf13f0897e5899853c0a0ff0840004c1a269ea076198b6e77a8de"
    sha256 cellar: :any, arm64_sequoia: "9d95d67bf5307be3db95b67910e35e234cba49f95d8f50993f7589d4100e0e1a"
    sha256 cellar: :any, arm64_sonoma:  "5b88ae647c20cdd4423988a5f7f2dc1fbe99274bab5b336f2e6a8f17758fbd14"
    sha256 cellar: :any, sonoma:        "292ac09a09485593842f6fcc2e34ea07cbf5197d7f1dd896080751420692a886"
    sha256 cellar: :any, arm64_linux:   "48b3063810119444562a48fd3a31416dee20cb3c091f06e268527e8da2f73f79"
    sha256 cellar: :any, x86_64_linux:  "446a3a9063450675a4e62738cc8009025304072f4810892cf4cccb3291f3215b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "libpq"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build with GHC >= 9.10
    args = ["--allow-newer=base,fuzzyset:text"]
    # Workaround for https://github.com/fimad/prometheus-haskell/issues/82
    args << "--constraint=data-sketches<0.4"
    # Workaround for newer crypton not working with memory
    args << "--constraint=crypton<1.1"

    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *args, *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end

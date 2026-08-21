class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v16.1.tar.gz"
  sha256 "ae9b5bc3f4cc97e28d28efa1a38aefb514ec9067acaa94fdc474e8d0a755ae4b"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1c9589735d54a686e71a59f4d43d0c7f9428d6eb806b8311082cce3ef2d9032d"
    sha256 cellar: :any, arm64_sequoia: "c052679d46fecca52f2ab609fcb33215d2accffcdf2a7254ad91cf67addbca3d"
    sha256 cellar: :any, arm64_sonoma:  "b563eb7ba62578b4b03a1d2c87aba12dcff9a7f33a99cd14c2f47f06d4f154f7"
    sha256 cellar: :any, sonoma:        "d27dc99f5e93ca4310b55fd069a52304a8dba75dfc83c4b5bc560593d6c94e36"
    sha256 cellar: :any, arm64_linux:   "7c5c741c906b6ab4d129b0d7f8714c84b098550ecb9ecb5f48d15cbf854b97da"
    sha256 cellar: :any, x86_64_linux:  "35914cd7566981e9bdf12fc56bd4541cc4fc80401b6a2586b78545c18879216a"
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

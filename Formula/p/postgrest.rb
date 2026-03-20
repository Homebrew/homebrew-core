class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.5.tar.gz"
  sha256 "ffdc596aaaa10254b0c92f9edadb54bdd83b2751efa2b8e05e0f2ae31f456c93"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e75c185ef1237b95628d3ca82dcdafc8ab14c629231106d9036cc9fb4137438"
    sha256 cellar: :any,                 arm64_sequoia: "86832317b978599c2fa1fa8a019700a57edf0263285a337830823321bea7c902"
    sha256 cellar: :any,                 arm64_sonoma:  "0d00459f941c960a98a4b5629c9276ad9c2abe68f334c5525fd7d2201bc08c95"
    sha256 cellar: :any,                 sonoma:        "f2fbdd7fc20abd3517679701ad3646e5f81ba46999d82c07f7b42ce6133a6e06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bbf2306f812d5cd090be39dec1a35d03dd3c85a2fc816fb97aae479621cf052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc6147bfe85295e6770c349cd6e2a62e3295d28c9f798d3c36fff420c46642b"
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

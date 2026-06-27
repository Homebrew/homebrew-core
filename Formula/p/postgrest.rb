class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.13.tar.gz"
  sha256 "fa8efaface8008e4565ee79695d3ea2d9f1647640156adc705095d82f225f0e2"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d5377af6b6c45bb473ff58ffc45c677125e9822fd2512d0e69af5a803b91eae4"
    sha256 cellar: :any, arm64_sequoia: "82fe07f53522257d56180e132859e5fc8009aad49778b5520255a3ad48511120"
    sha256 cellar: :any, arm64_sonoma:  "f05ea23408b8a535d8e3c945c28c9b93bafd79c4c6a40cfa251537bdd2689dc2"
    sha256 cellar: :any, sonoma:        "858a51f14b5b246b739368d54022e8b4e5d6d9c53facea71a6075b2ceeac5bd1"
    sha256 cellar: :any, arm64_linux:   "781bc67901e8382714fbe33941ea7b7377aaf5f376af7d162ee172b6315c5c63"
    sha256 cellar: :any, x86_64_linux:  "79c30104c66320bf863b2bdb7027af60c9030aca449a832506c989fef3403e63"
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

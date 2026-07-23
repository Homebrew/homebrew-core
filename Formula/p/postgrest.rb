class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.15.tar.gz"
  sha256 "411af89ada07bc5ba84c5690d533eb13d276b12e7ed1b7e9717cab14fccef1bd"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "74f2f7ff0ca45ded40a1a129059f27f15ee308d1add7a16a591904b51a8bc4e7"
    sha256 cellar: :any, arm64_sequoia: "4e9328264634c94f5758f807c707030484c5698c12b50e329c44e3df334cadc0"
    sha256 cellar: :any, arm64_sonoma:  "ea17be324093b516927897158a45fa64d2b00b066e510aefe1affe3e332e5d98"
    sha256 cellar: :any, sonoma:        "f3e02d9bbfb0bf8b8c744aff96eca02de5db8da6d5292024d67fce6dfb7ef0ad"
    sha256 cellar: :any, arm64_linux:   "c0bee034938f4a4e70d250cd03be30df7df81303b347d465aed88c5370880482"
    sha256 cellar: :any, x86_64_linux:  "6cfd89324f515336cbcd474dce7b16368ff3fda67e06bad9697891314909b924"
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

class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v16.3.tar.gz"
  sha256 "deaf7fdb697e6e539ec251f02e62a53616bda5aefc17e281a4eadd0b6bc315c9"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9d9f8271ce9a33412ce870f6f32dd896bb101ab4ef9eafa4f8795461a0368975"
    sha256 cellar: :any, arm64_tahoe:       "8a0696a0cf7ce00b4bc7092f865255dbd67da49b3935ad7fea67e9992a4c59a2"
    sha256 cellar: :any, arm64_sequoia:     "4f45386a5b0df5ce0a9daa6f241d23989d4c91b7ddbbcd6ea99ee9cca3c3857c"
    sha256 cellar: :any, arm64_linux:       "263fa8464591ddf8115adf53b49ba40f5a0ccdb9fcbcf4904f89438ef7b89855"
    sha256 cellar: :any, x86_64_linux:      "e546dc799bb42d2707a3e84f756d478672563461c0a7aa1bbc4efb769d31b7df"
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

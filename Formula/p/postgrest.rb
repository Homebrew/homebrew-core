class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v16.6.tar.gz"
  sha256 "5a532749dbcc008984724b8b306829f36bf651d35958e2f0eb27cb080bed4a33"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4224d2430292385f5894ede7bde5fb89bd599ccde7ccf8b8744a396f5b32a5ec"
    sha256 cellar: :any, arm64_tahoe:       "4fcf14b3106049d0611f679e22e5259704312a4afb369cacb9ead681c1cacbc3"
    sha256 cellar: :any, arm64_sequoia:     "b316b8e244d108f8e8a9a95cba422d15bacc63a820f06ed2efb8b7ca40691f8e"
    sha256 cellar: :any, arm64_linux:       "81e09ea9f9daaf678377d8cb73d1a06721951781f4f16015831d80f2446bc2e9"
    sha256 cellar: :any, x86_64_linux:      "6ea3cc3a60d5ebdec603a7f6e85099ed640fbc1e779fe2c1427a7f5c1b2fc346"
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

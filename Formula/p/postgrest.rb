class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.11.tar.gz"
  sha256 "876f29cd3826d44b73cff3f49bf85e653650cd76cfb1f9cf6feaf3af3b3a4721"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9da8cf8329cdad2c37a7ffb604b5cec0f0d022cc51f53bc89bc28af1a1181e59"
    sha256 cellar: :any,                 arm64_sequoia: "29212a0e544f7684075e666893b8504c16949067dbcdaa0336c4624cfe8d1cb8"
    sha256 cellar: :any,                 arm64_sonoma:  "dabaf5d3920fbff4c49ec114160dd0e029e952287043e5ff7cc33d5233c17b5d"
    sha256 cellar: :any,                 sonoma:        "9db3f887fd13cfeec00a51a9da1de4febd5cd9308964c160e23faca20649c94e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf3715361f66de61630ac5818db485ba1c394c56c437c4a828055ee7bc05149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd4f564149828617b0b4234306644c686cfbe2c575542c6e42ce25f8e38865a"
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

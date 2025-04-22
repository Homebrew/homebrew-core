class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.2.11.tar.gz"
  sha256 "7e99b36e293b2a695dceff477a58bc5ff3aa4ece3e369fb4017bd78d2caa7f90"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87960ae6605e7a67a63d6929cfc702fc633329ca70ea4304d23de137bc20e573"
    sha256 cellar: :any,                 arm64_sonoma:  "6360eb78dcad017933aadf73935a2e29374f12c1730f70d1c0476585157c31d9"
    sha256 cellar: :any,                 arm64_ventura: "7bfcde1b782b2ef4db2dde24bc81069895db5c8d7167562945b90f90f9ac660f"
    sha256 cellar: :any,                 sonoma:        "0b6146652d86361fa00b6c40841fd8606e5130cf2426a0381208631b96b71ccb"
    sha256 cellar: :any,                 ventura:       "3012f073eaf3c0d9508633a3873c7926c4f32fd8311268aa9825bb5ca51a5638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70f271a579aae8aff31fb0d5c5a57a904d63d808e21755cd8e297ce99dd3685a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d68529b666a0b38cfba142f0165d5f0874113f01e5fb5cc4a73d2bd26d59036e"
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

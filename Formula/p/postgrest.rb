class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.2.5.tar.gz"
  sha256 "b0997f9836acb22988e31e32c620f09d9ffbdc08a8a23ebeb945eb636ff8eeb2"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a40be6c7106340768d60305f1b2f025b1b14efd101388a1e0f25b77c9ad4ba5"
    sha256 cellar: :any,                 arm64_sonoma:  "2f2e2ff485b9ac90ca2d8dca7dea06bad00c10321fac3f672cefa3dd73aa3e15"
    sha256 cellar: :any,                 arm64_ventura: "c4854e6b1b4d5fd72b448901143d95db54348e8a5ddf1ab38b90e0f5ee1905ea"
    sha256 cellar: :any,                 sonoma:        "c8fed6b477de7e6b3849e764c5f70d6fbc689adf498ed745ced3d5e84dbcde39"
    sha256 cellar: :any,                 ventura:       "625ba2baa090ceb4b69fb873964dc241381ed9555d1c2a3aed87cf599acac96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a99bad8b632345a4b0ada05e112e6b387121bce9d379eead210b52ea8c19236"
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

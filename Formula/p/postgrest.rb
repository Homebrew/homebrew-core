class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.2.12.tar.gz"
  sha256 "d748a81a3127691d46e7e2546a5eb0e77308b20190c2315267b6785e66dee0fc"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4c873681dd0d0ef13f0641ec9a5f4f52aadde9228527367c58cceae872908bb"
    sha256 cellar: :any,                 arm64_sonoma:  "ebc0347179edf1dd6f5b8f9ac22725252357ac2cbb6cf00193c4955e44c84c2a"
    sha256 cellar: :any,                 arm64_ventura: "da7f4e4822b47c42305be6ad6558da1678d7ad40be7cb763d56d2041699bbf0f"
    sha256 cellar: :any,                 sonoma:        "e33dfc41bfafc29e1c242673f4a74e1e397e53c08514f0f420326a04c0d7b14f"
    sha256 cellar: :any,                 ventura:       "f0abe5105f6f97ac61b842a59af4d6d0b5aa27c49b57dea99f01033ec9f39b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c17d0bfe395d15ea32a163265fa466410b305ef79cc75662c470d17869d641a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7917700b0d68fc45ce792899da3941ccd0253a75cb6314d5bb4fc00040116e1"
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

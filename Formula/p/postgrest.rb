class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.0.3.tar.gz"
  sha256 "cdc3524f5a44a2b6236e7909861d17ae8b8871fc3763d2f1c3c07c56ab52ff70"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2dcfd49829ce31df6445d8b0c8d717584d5d116665b5b3d21addeaef94e55c07"
    sha256 cellar: :any,                 arm64_ventura:  "e17a8c4b29907fd3cdf89367709cf551557654e417235f1976e62c6506514ee8"
    sha256 cellar: :any,                 arm64_monterey: "ea3287e2f8210a96a94322a0bd44dfa029480dc42d45b9cb41833c9aca0e43eb"
    sha256 cellar: :any,                 sonoma:         "274a105ebc1329d288db9004536bfc98b3f0428de2e2195515a5233b12f3f921"
    sha256 cellar: :any,                 ventura:        "1a42cb8e8e65caa78457ec46230903ca160d9337dd57b5a924215d4dab3058f5"
    sha256 cellar: :any,                 monterey:       "be7c87e8dcfb8634951c8dd386502290d01f7f3f2de1f4c5ced892647977821b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "923af96f7e1232988be2f694ab1541805314ecc94bc64ccf86d92d5baf2c57ba"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}/postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "An error ocurred when trying to query database settings", output

    assert_match version.to_s, shell_output("#{bin}/postgrest --version")
  end
end

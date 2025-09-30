class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v13.0.7.tar.gz"
  sha256 "873e1be528050af36585e00bf40716b3d1f36effebc836e81e2bed6f028912a0"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71760598c80a29fedf3b11849ca2ff3dce6a9cf8022a52c8d6d819bd57ec3834"
    sha256 cellar: :any,                 arm64_sequoia: "d04cb7f65b6b60af8c5ce7e5eadb4ecace7da59735ace0d5c9beb9dcfdf76874"
    sha256 cellar: :any,                 arm64_sonoma:  "af8321781f2942ed09d8cf812e53714940d89e4bdae05cb3a59836034a08026b"
    sha256 cellar: :any,                 sonoma:        "611adffece389bf2134918d8ac3316585bbe21a5da9c1345e0a1a6410f2a71cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cfbe45e2ea7a24dbae4c8f6c2a0100e05eaa3a463b439ccf846b7050897e698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7dcfed11bf647d210c5cd788e2315775ee851a13a160541d498c0f10884206"
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

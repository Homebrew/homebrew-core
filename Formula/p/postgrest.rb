class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v12.2.7.tar.gz"
  sha256 "4e5e74c9bb64ab99ee14b4cd90b12b270d3bfa52500c139206d2ab246940d815"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "247666f06601901f6fd4a0d18ffe9c63f7efe741819768a2a01d81a5227fc2a5"
    sha256 cellar: :any,                 arm64_sonoma:  "aaff38d08638b71765a9cb008fa666ff04642ef5bc9d1ebfdf33052cffee0704"
    sha256 cellar: :any,                 arm64_ventura: "8888215eea8573abe277875461d0fe2a41623b4d39aacd054d7fd68c08f964ba"
    sha256 cellar: :any,                 sonoma:        "a9be01b5156c1700ca0c3487dcb91501a1fd7f859dab9864c806f1276dbcdcf8"
    sha256 cellar: :any,                 ventura:       "a7b1fc81a398413ed2bc53c008c1abe0446e66877bcbd48ea30373a70a6c6afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2545a94bd572c8b0860109e7ff034d282df3c8ddb4b56353170edf2cf4fab3"
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

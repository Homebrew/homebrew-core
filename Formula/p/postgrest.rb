class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.1.tar.gz"
  sha256 "b5927f9fb196cdf814953d028b18a3d62c0a2d159548b80d490427561a6c5d1f"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc1aa392b996df51edcd77fca37ef0a2e128d608f6f04b64e7af2e81eb09cfc4"
    sha256 cellar: :any,                 arm64_sequoia: "841881179ce6dcdc096ab109fdbab649cf9ea035a738aa0dc0db67a81ffcfe3b"
    sha256 cellar: :any,                 arm64_sonoma:  "40deeeec91c03200c16ac04309d7eed495be2f74750e0068467c45cb6af512a1"
    sha256 cellar: :any,                 sonoma:        "8987e14e79a41a875e1d973817853a04a4aaaf3c6f9d7256b6d1238bc1d73306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031fd1d3edd6a08e50384f6c98fd57ff52b797cbec526c25dce32b606447f7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004417f8308880fd38d1247bf40ad6887f523831fb1a44e0c7edef2878e201e6"
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

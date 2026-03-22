class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.7.tar.gz"
  sha256 "47e375b43d0f958a985c2708ca29f6db897c7390096a728767cad74b4a8767fa"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8ebc0ddf5540bce3e571a32f831250faaee842b634abe3d90f50aa2f8a89d83"
    sha256 cellar: :any,                 arm64_sequoia: "1cf88580188fffc4c353d01854f9aad3004011a8a2bf4ccba520797adf36de41"
    sha256 cellar: :any,                 arm64_sonoma:  "9f0bc7d5592d2a177a9ecfb159bb3c783313ae0dd1c047525d5e4dcf2130d85e"
    sha256 cellar: :any,                 sonoma:        "8c75083c6a64444bf8286dc0fe9d9a6333a823ca2279c0d2caed16130f936ce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cae822f9ff53700b49447218f6d566b16d601b525f98ad49e18545001f8df8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c94ddb40c049abfbf63a52dbbf243b70120998c0c7ebec32e76505b2b9fc7839"
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

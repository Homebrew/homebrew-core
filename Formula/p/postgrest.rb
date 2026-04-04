class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.8.tar.gz"
  sha256 "d87641828f39a487e52ec50bc4a741975de3a1a189beee57d7973f1ecf452e1c"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a57fe4fc766688c48b9a0e921128b96a9cd7fe2889d669c334429d8fb275be83"
    sha256 cellar: :any,                 arm64_sequoia: "0c1414effa1ae0f37b33ae2d7d4a5cc7a3985513d16ba3af13d7d13b81c50b85"
    sha256 cellar: :any,                 arm64_sonoma:  "9c740551e5b97cc02055fa0c1010c7c7d0a63c36b965099af8a0f849f0712331"
    sha256 cellar: :any,                 sonoma:        "6f5a68fcb6e3347b7b3984287cecd5fa1de0d3fa9f8ba262052c4c7f17a555c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b40d918c69508b19ebe43218fc25ba22a6671c1351b6347513bac3ce9e8d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d25875a12678f6097fc65d6a74db649362216d33de333ab83aaaf726f18539"
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

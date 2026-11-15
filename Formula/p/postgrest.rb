class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v16.5.tar.gz"
  sha256 "d8c4862d2bb7b0a5ca33d197cc34293bcae4a448c1e69707c303922cdb67ad6d"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "17d9dfd81ebc55b24da7921b8d8babd42dd8536e790b10ae5bb052e83826100b"
    sha256 cellar: :any, arm64_tahoe:       "3632963a37740667da66d83f26794e8bcfd3c7c07888be9402c61e154a7658b6"
    sha256 cellar: :any, arm64_sequoia:     "b18244320723aa9e56733fb061daf0f77c211b8384aff72881aea31830cae91c"
    sha256 cellar: :any, arm64_linux:       "bd37c5962ec4cd637ac65e8533bcf0308aa145fe65639481bd1acc3017c35574"
    sha256 cellar: :any, x86_64_linux:      "df8bf9633389d57fdca8f03f8c64242e1171b28c038f0cbe083fa37004426b6c"
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

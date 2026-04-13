class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.9.tar.gz"
  sha256 "df085b51fbbcbe64762d16f174d97facf21060eed382a11404abe4c7607d6221"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5327d064294e92cedad75a4a551164b764f1fa165b67ff2869953ddef57af512"
    sha256 cellar: :any,                 arm64_sequoia: "7ad03842b4a08f6e28759fe43795d3e24f4eec4604cb38fe54c41edd6d890640"
    sha256 cellar: :any,                 arm64_sonoma:  "2439f466747be2979ef445be2dc1d3baa715cc7c2ab7c261659e97def5ee511f"
    sha256 cellar: :any,                 sonoma:        "b716fd3c18d2fafa25e3f66290b22040bf7f410fbbc3a426f76ef80c2255bb7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e121169f82830466cce858f532a88eaf550b66522674cb78d4c21cf67c9c9559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db66106ec7d7ab3d45b42039c9a9ac8e5d8ae78f0e13827c96c69a588ce65563"
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

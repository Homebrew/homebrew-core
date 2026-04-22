class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/refs/tags/v14.10.tar.gz"
  sha256 "ccfabc0a819397c8deb191d59130128cf6abd948566a3f601478e4a58cc829a2"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aed8db9080a854382c7cc51dc097b8ba28cfd8d5324da9988240abbbe453d256"
    sha256 cellar: :any,                 arm64_sequoia: "eea9aa41077f307435ac131c7bead88678bada1dbe695651f6d181c459efcc54"
    sha256 cellar: :any,                 arm64_sonoma:  "1cae227d0fa24599898cd52919c866b429d79a570300d1dc269f5b97af6d3ac5"
    sha256 cellar: :any,                 sonoma:        "5ab968283017aee03db7814fc44021dd256757381e0741a904b6ffb9c1d635a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca0cfb99e3eb562d180ed2fd0dad532303b9c4aeb53b3bac2647cccfb24eab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "091d1733ce2ec7892adf134e6471da9d79d1200f63ae4f29175dafbd991636c6"
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

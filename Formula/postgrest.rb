class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v9.0.1.tar.gz"
  sha256 "45ea15e617c209fffbbff90d90f55237cd15d62a4600d1bf86c87693fb973702"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "42944adf10de9717f24e87f2cf9ed58fb1cf2c4b3a5720d047cedb50b7fafd79"
    sha256 cellar: :any,                 arm64_big_sur:  "23819a365f67d9be02599d9a6ce66f70d5d2d64d54d7828156a2008793450de4"
    sha256 cellar: :any,                 monterey:       "e5e0124159c0099b01986015830fada6b5096488db7d33aa4d0702762052c1c4"
    sha256 cellar: :any,                 big_sur:        "2e69962c69b9c2adc0f11ab2de8580546f6221ae3c3dce0a4527b899a772978e"
    sha256 cellar: :any,                 catalina:       "65b917925217316d1d1efc7d4b3e00ef17f9bdbb14650c6d2aff8d2d406d1c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c252ee6b1f53fd611cd4dee29fa9e581c34fcc254f668317da600580b2839fc9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

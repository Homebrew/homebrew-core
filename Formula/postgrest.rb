class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v7.0.1.tar.gz"
  sha256 "12f621065b17934c474c85f91ad7b276bff46f684a5f49795b10b39eaacfdcaa"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git"

  bottle do
    sha256 cellar: :any, big_sur:     "bb885e5c86b0e997b660b0ab3975d59c458f0db4436bce9ea158b89c65dcd6e2"
    sha256 cellar: :any, catalina:    "691546e89701fd582d47c697dc27551ef3284ee21933a5912f406e6fee4dd272"
    sha256 cellar: :any, mojave:      "34c0413e71a41bc8550b7ea5286e0330aa888990d2e2a8fe6d81b57152c83d61"
    sha256 cellar: :any, high_sierra: "6ca3bb9cd14c9ab4ddd028493e4ffd70ddae571be74723997b677c6c67542c87"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

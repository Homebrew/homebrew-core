class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v8.0.0.tar.gz"
  sha256 "4a930900b59866c7ba25372fd93d2fbab5cdb52fc5fea5e481713b03a2d5e923"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "bb885e5c86b0e997b660b0ab3975d59c458f0db4436bce9ea158b89c65dcd6e2"
    sha256 cellar: :any,                 catalina:     "691546e89701fd582d47c697dc27551ef3284ee21933a5912f406e6fee4dd272"
    sha256 cellar: :any,                 mojave:       "34c0413e71a41bc8550b7ea5286e0330aa888990d2e2a8fe6d81b57152c83d61"
    sha256 cellar: :any,                 high_sierra:  "6ca3bb9cd14c9ab4ddd028493e4ffd70ddae571be74723997b677c6c67542c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19d9eb67047672cbe7327feba36f70f8e85c85690fc9a73b8970998eee85b8bf"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

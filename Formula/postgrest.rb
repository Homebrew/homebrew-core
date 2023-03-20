class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  # TODO: Try to switch `ghc@9.2` to `ghc` when postgrest.cabal allows base>=4.17
  url "https://github.com/PostgREST/postgrest/archive/v10.1.2.tar.gz"
  sha256 "4132e8a329775efcd6e84024aeaf457a34141c3ad0cd88a0aa3aad11d190a979"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5428f383e55c33945512e5e24f233a816587ee05efc9efedef87f31499538e13"
    sha256 cellar: :any,                 arm64_monterey: "7df9ba1554b339e8fbf7de7caa09cfcde30cd39437fab4b3c5512f97e22e7483"
    sha256 cellar: :any,                 arm64_big_sur:  "657f0e5aabcd7b2b7e5603eeda1e1de56b604e98afaa89c3a89fa11b0441eb1b"
    sha256 cellar: :any,                 ventura:        "11a1ea851efd894dd767109453c24e91470b9c38e0a0ffe386ef859bd1583652"
    sha256 cellar: :any,                 monterey:       "f976df98b85d673c4969f38de2be86318294a94846b00cd0ca910de457e42efa"
    sha256 cellar: :any,                 big_sur:        "d9cd59a900c685e66162af0ab6a8712ceda06d8ef560257b27e4d68705b7a646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d1bc00e69042a4d248648a4c9ad7d5b4c5fa1171752edba861b2edfde0c558"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

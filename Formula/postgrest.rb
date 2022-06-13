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
    sha256 cellar: :any,                 arm64_monterey: "362080485eb1f0774ce8b55c590c03a492e80b9b335d89e9ba76eca5ff697b65"
    sha256 cellar: :any,                 arm64_big_sur:  "68b0de62dcba433134d60302e30739ae14aeb34d4ead2b370b96d48fecb0d351"
    sha256 cellar: :any,                 monterey:       "6070e9de0d2ba5954fb2f85d0ca853d841138b33c7c8ab174c6a9eed023333e0"
    sha256 cellar: :any,                 big_sur:        "cf0cca247489219a05c38b9dca79b8dd2f83ee23e31eb578c8790ea5c47f0af5"
    sha256 cellar: :any,                 catalina:       "a3c2c2529b32b090c71e137ccab2cbfddb1c434b14a07e9ca56bb5eab2523913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20bb76251eeb3b4a7a4a320e2c1aef4f6c50e634fde423f1c89ecf3c85e9846"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

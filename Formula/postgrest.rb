class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v10.1.1.tar.gz"
  sha256 "d8479065eddb6ddcd56835e5da4cb2359092b7934a1f56f4080f7d8cb0b24557"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6e3487057fd0995e25420d30f7350e98da5dda1904b9876175fbe8d7540eb46"
    sha256 cellar: :any,                 arm64_big_sur:  "a7ce47936920a047e0b9dea9d4faee946527079acef62fc6fab4b9ba1f5d44b1"
    sha256 cellar: :any,                 ventura:        "c51015920bf8d7738f61123f4f7b89d24ecf50c54ea6622b6b3787161419a6f5"
    sha256 cellar: :any,                 monterey:       "bf1ea1297d58b652e6ecf15c78991fdeb5dbcd6732e7311281ef032bbc82e89b"
    sha256 cellar: :any,                 big_sur:        "a078208e36a47e8a54516eb0847b715b86122004a3e23da7fed97c6aeb52063f"
    sha256 cellar: :any,                 catalina:       "b08dd4bc5e914b85dbdb7ede3dc99696195bd67673ff7b22a9a40cf873b09376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8673c5cf90a5dcf8a199bd5214cbd537f6bc542c8202cdc721b171d7ad02fffe"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

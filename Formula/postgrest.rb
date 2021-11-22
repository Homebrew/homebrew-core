class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v8.0.0.tar.gz"
  sha256 "4a930900b59866c7ba25372fd93d2fbab5cdb52fc5fea5e481713b03a2d5e923"
  license "MIT"
  revision 1
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bd989403d46a8f5fa86ad41e813fb48e06ec60d6b4052f6bc5a3168c22671ba6"
    sha256 cellar: :any,                 arm64_big_sur:  "a505a99c6f164a72936e18584d9a172204be89694934adc2a4d168c33ae8f91a"
    sha256 cellar: :any,                 monterey:       "c6d67ce89f433586f9828ebd36be1745161366c42750bfb896ddf939e3083d90"
    sha256 cellar: :any,                 big_sur:        "9cbf169535605656b931ae0065af5a57c2ff511a8b50529e9ded33c560306c29"
    sha256 cellar: :any,                 catalina:       "af90758e13856d719d8fc68f770cd59356081321a90e68c52dd8d897fdcc8f4b"
    sha256 cellar: :any,                 mojave:         "e2a7fa323490cbd817ec9a74729de4a7692d64f2c59c4bb73e188c9235340400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c47b193a23f58ccb2df1978aad6df9632428f9c7cccbcbc6fb6eae69b6df87"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

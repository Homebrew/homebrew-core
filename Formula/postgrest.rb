class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v10.0.0.tar.gz"
  sha256 "34e09612e8ad2f26fc6897b41ce2c260497a89425c3860be17c369ddb3229c3a"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8f16ffb2efc906c2415ac28698740a8a8381d0bd2fd2a1085962e3bf0ecf1133"
    sha256 cellar: :any,                 arm64_big_sur:  "bc89572983d9bc6ca4f8602688aae4fd53623de1e6868856e6321fc3b0ec1491"
    sha256 cellar: :any,                 monterey:       "98dd4a692dfb57ca9d30c75e7024f7ce2a10320b19e75f55c0e639f74ec3a125"
    sha256 cellar: :any,                 big_sur:        "2b397c225111a0f50fb2f2a44f6f0b7e11c3e658622b0e149532b2ff76207728"
    sha256 cellar: :any,                 catalina:       "f4bb0697c939dca690215922cf17658d152a45c7bc24c657e7ddb4f991dcb0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2116b90dbbf22eaee5025af239dea39224bcd95a7c7156137180263fc0f6d3a3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end

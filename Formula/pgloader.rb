class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.9/pgloader-bundle-3.6.9.tgz"
  sha256 "a5d09c466a099eb7d59e485b4f45aa2eb45b0ad38499180646c5cafb7b81c9e0"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "adb28f200082b1bbfa36592f61d339099ffddb124b97151eb9122fec5d79a626"
    sha256 cellar: :any, arm64_big_sur:  "e9dab1b1c654d6d86eac9d613a21f96afd64b662eb36f919398d93e5ac3d7a09"
    sha256 cellar: :any, monterey:       "d6db8dd33e781a6b6eb88944d6f6f94113015d06c787b8ee847d891ed112b6a5"
    sha256 cellar: :any, big_sur:        "8e7792576a8dcd5fb4c36a665da15c134982ef5b1298fbec7886fdedaa427144"
    sha256 cellar: :any, catalina:       "397290ccc7b1135e622606ae625e55ce07d2af7c9a3c72aec8c8f8638a245969"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end

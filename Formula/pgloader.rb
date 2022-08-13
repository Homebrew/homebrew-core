class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.7/pgloader-bundle-3.6.7.tgz"
  sha256 "25f1767a5d2f2630c0c81da5dc7e1d2e010882799796b094558283a63da33356"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a95d9ebc8ff9c3140cdb070434f9a79c2a99872bbcb9a7ce969b0b9d4b5c62f5"
    sha256 cellar: :any, arm64_big_sur:  "2f9cb725bc9fa65a14b0048503c6f9396a0d465d8eda3f64fb05bf69cf2a58ab"
    sha256 cellar: :any, monterey:       "c0eca2b1beac15e03853b366cca450129b4a40017fcf0e09dd405192507be46b"
    sha256 cellar: :any, big_sur:        "02d2b43ec234904659d4f254f21ea5300bfd8d6785381e57bf755f17518a897d"
    sha256 cellar: :any, catalina:       "d23a5354cb53d4e4d9a20c5f8eb6bcfb79b5f406026de7f157f7bd6b41056beb"
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

class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.9/pgloader-bundle-3.6.9.tgz"
  sha256 "a5d09c466a099eb7d59e485b4f45aa2eb45b0ad38499180646c5cafb7b81c9e0"
  license "PostgreSQL"
  revision 1
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a1afef6471522bb9640eb6a1f90a81de9a2b7a59486855b01126a0a76a7d9202"
    sha256 cellar: :any, arm64_monterey: "18fc4491b7d3035915ded7094ca86ce1201f5102f0b1197ac01da12025d0d51a"
    sha256 cellar: :any, arm64_big_sur:  "975bf337d97d1f1db5dc0beeae7b239bfcc9077f41ee509bcf7b8ca2e94b8445"
    sha256 cellar: :any, ventura:        "4e5a10a893c483e90c08fe80a5df7192f8242ff91a05ddb853ef0393538c1eb1"
    sha256 cellar: :any, monterey:       "dbdcb3dc4b0a403a1235646d7246efb94f31234a1fe6e300a632099b58b81921"
    sha256 cellar: :any, big_sur:        "ec2d67c75bf8ee60a466446161052a64a8cbcf1a2b89572949a763a134d23a07"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end

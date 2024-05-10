class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https://github.com/ndevilla/iniparser"
  url "https://github.com/ndevilla/iniparser/archive/refs/tags/v4.2.tar.gz"
  sha256 "dbcbaf3aedb4f88a9fc0df4b315737ddd10e6c37918e3d89f0ecc475333bde4d"
  license "MIT"
  head "https://github.com/ndevilla/iniparser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "753beea9006c031482f9438c896d2113ec957977436a556a7ddda278e519bc12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6587bb8045a7680ca5b9388c25b026d5d8409cc4cb949ce9d3f090882ca7ec3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a0f764ffc134ffe9f757c38ca6f2c4033ba487ef2cee93769c6d0efbfbe1aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e1b7716bfd58338f232bb5d3df1d77cdd51b5e5cfcb0cd19b6a42981bc96d8"
    sha256 cellar: :any_skip_relocation, ventura:        "59d0194ace1f55d5e84e5cc814834b753045ccb7008c8b37164481fe7b98b9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "4ca47d04de8b746554aace33f226574133c971eb9d631e6a2d6afd13b208cfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461f631dd414684e21666e4965990cc9ebd71b04e59e9b739cc291eac5195f72"
  end

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end

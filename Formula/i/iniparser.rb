class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  url "https://github.com/ndevilla/iniparser/archive/v4.1.tar.gz"
  sha256 "960daa800dd31d70ba1bacf3ea2d22e8ddfc2906534bf328319495966443f3ae"
  license "MIT"
  head "https://github.com/ndevilla/iniparser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b7f315ef24e0b8e9252772fb3ec750dcd13a90796eca266ae9dfefa50ec059f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62dbb35ffe023cea60e167ba6f6a7242d01274868df203944298be40159fe123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b8550dc64594120847c937c9b1a4e10f6c81622de2610fd0d7818bb35b7f45a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b4cf68e72fa3eaaceb96f97cdd38d4fb4794492f2baaecae1055d9d4fbe52ca"
    sha256 cellar: :any_skip_relocation, monterey:       "1fee5c56cf1543f370b6a940a3f11aae2d1fe4517bfd98a3b5f6265d20aad32b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c46428d183d6cee7f196c7a2a5ba81eebf078900c2825b7c9d3186eb91391b8"
    sha256 cellar: :any_skip_relocation, catalina:       "bcda9d9c41e5ecf09a748eae0c6054c92ce858df53d835e5454310ea4f731a8c"
    sha256 cellar: :any_skip_relocation, mojave:         "69dde8e886645f5b89f83f36835c18449afe7f6c4f119d466d7f204e994952c7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "cec20d33114e7a5811acb41f9f9a36a411ffd2eebb7d537167b9b541b03fff8d"
    sha256 cellar: :any_skip_relocation, sierra:         "7ad8eb3b8a66c08b78d2d9d3db18bd50e842d1c5962600ad0c9c8244d296dea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff54f4bdd772ed7f7695079046c3668ab088e233e4f1939bf699b4b7219b964f"
  end

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end

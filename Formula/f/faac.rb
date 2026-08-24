class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/faac-2.1.tar.gz"
  sha256 "1d4b890c7d767361987d80afdacdd654d23a748b4a273d743c174c2d57e9bce5"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/knik0/faac.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7fb6d41c0a19e3572e4df9c05b0049d09e28f54b38424a628193c05dc0c7203b"
    sha256 cellar: :any, arm64_sequoia: "95d1fdc48ef74a29d1addfcdfda4ed19fbaf9996b394c02f18f4b37818e9747d"
    sha256 cellar: :any, arm64_sonoma:  "3b1386b6f68b057a215b3f923fc86eb900d5958da6ad4f6ad3c7e80a4b24fd64"
    sha256 cellar: :any, sonoma:        "5cef49a9b8e42188fbf9604cb1294b2b448a4a607ebf2a097803fb706e269266"
    sha256 cellar: :any, arm64_linux:   "ebd25c0a9ef02a689d08ec556f9ab0e7f26f2f96edc224c0659e1f13c0af0bf4"
    sha256 cellar: :any, x86_64_linux:  "47911348bcd7aba4724b78f524d9a44d226ea630b0f47e7eab25660ade7a6c23"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_path_exists testpath/"test.m4a"
  end
end

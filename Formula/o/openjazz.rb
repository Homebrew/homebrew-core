class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "https://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/refs/tags/20231028.tar.gz"
  sha256 "c45ff414dc846563ad7ae4b6c848f938ab695eb4ae6f958856b3fa409da0b8ac"
  license "GPL-2.0-only"
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "07a222337046a16eb095259f2a5952d2893279bb5dea456df5db6a04d0a464a3"
    sha256 arm64_ventura:  "c5c520f1a957586f0d8a9a624db938ab0310f1beaa6b89e5b0ed8a64cef6337c"
    sha256 arm64_monterey: "df4726038828be4f5c0297724794355b57988a3418d82f184d26345c3fe29bcf"
    sha256 sonoma:         "bee571f4da0e9d27a0e165e349fe3bb0987e781367bd6e1d951ac841d63973a7"
    sha256 ventura:        "319618c494484856acb274b82f8a32232e9a2a022bf704ad638b599885b4009a"
    sha256 monterey:       "a420f6753dd4676cd8c2952e81c46d75f9c558d1ea07dfb5de95f1c69b272cff"
    sha256 x86_64_linux:   "f6f7b98ac0aa8679388825ae164c71441c5b4e54c24344d7041b2c178a22a51c"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  uses_from_macos "zlib"

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  def install
    # see https://github.com/AlisterT/openjazz/pull/100, can be removed once merged
    inreplace "ext/psmplug/stdafx.h", "#include <malloc.h>", ""
    system "cmake", "-S", ".", "-B", "build", "-DDATAPATH=#{pkgshare}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      The shareware version of Jazz Jackrabbit has been installed.
      You can install the full version by copying the game files to:
        #{pkgshare}
    EOS
  end

  test do
    system bin/"OpenJazz", "--version"
  end
end

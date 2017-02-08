class Nethack4 < Formula
  desc "Patched, fork version of Nethack"
  homepage "http://nethack4.org"
  url "http://nethack4.org/media/releases/nethack4-4.3-beta2.tar.gz"
  version "4.3.0-beta2"
  sha256 "b143a86b5e1baf55c663ae09c2663b169d265e95ac43154982296a1887d05f15"

  head "http://nethack4.org/media/nethack4.git"

  bottle do
    rebuild 1
    sha256 "ac7e833109caa3a6c4a365170440945aafcbfc35dec2be0bfa62ced758c9c17c" => :el_capitan
    sha256 "6a1214f77c7906081e7ce8c32faca47054fd980f5d342aa5e872cc6599ecf682" => :yosemite
    sha256 "0f07bbc26d41390eb75ff3fe03969d0de5cc41fb07aa16435ecc515882d77444" => :mavericks
  end

  # Assumes C11 _Noreturn is available for clang:
  # http://trac.nethack4.org/ticket/568
  fails_with :clang do
    build 425
  end

  # 'find_default_dynamic_libraries' failed on 10.11:
  # https://github.com/Homebrew/homebrew-games/issues/642
  fails_with :clang do
    build 703
  end

  def install
    ENV.refurbish_args

    mkdir "build"
    cd "build" do
      system "../aimake", "--with=jansson", "--without=gui",
        "-i", prefix, "--directory-layout=prefix",
        "--override-directory", "staterootdir=#{var}"
    end
  end

  test do
    system "nethack4", "--version"
  end
end

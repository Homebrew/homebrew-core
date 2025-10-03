class ExVi < Formula
  desc "UTF8-friendly version of traditional vi"
  homepage "https://ex-vi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ex-vi/ex-vi/050325/ex-050325.tar.bz2"
  sha256 "da4be7cf67e94572463b19e56850aa36dc4e39eb0d933d3688fe8574bb632409"
  license all_of: ["BSD-4-Clause", "BSD-4-Clause-UC"]

  livecheck do
    url :stable
    regex(%r{url=.*?/ex[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "c058c623956ae2057e5bb4a820c91b5f0bf3febf4f128f0f7a6e65a2d5699646"
    sha256 arm64_sequoia:  "6de1a4ee29d49c4230c0d9d044bfee06fdcf5d676c665ae422cf66a25727c398"
    sha256 arm64_sonoma:   "69b42aa6f4240ec7564308971cebb89d784b234787e541d9944abb188be9e76a"
    sha256 arm64_ventura:  "eabacdbaaa34c071ef481026c5594fbd4a40b562b1b26c334d32af0bd007bb96"
    sha256 arm64_monterey: "a3f2d4dae8f7b2701020c17e9d36dae8e20145b08cd65eaceceb682db73d9033"
    sha256 sonoma:         "56c46aa6633306d709c283a85b38cc61ce2ff3d12f31bffe52e6e3aecdf968a6"
    sha256 ventura:        "6d2ef3fd102c883b10e95a0a491046e9bdfba6615fdc866a921f058440346da3"
    sha256 monterey:       "208b22e211c6e66ca63b30ee214dd16bca6f8c0ebbea8980f738501eb3f0d7f1"
    sha256 arm64_linux:    "f8d06fd838ebda25c906af23482f4c72f903656d79b86b5c59c1156032b3e989"
    sha256 x86_64_linux:   "6db96a6326a1359f5a5c08b05f918256ad6b9b04fd0f2a36d1ea22ec41372788"
  end

  uses_from_macos "ncurses"

  conflicts_with "macvim", because: "both install `vi` and `view` binaries"
  conflicts_with "vim", because: "both install `ex` and `view` binaries"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    ENV.deparallelize
    system "make", "install", "INSTALL=/usr/bin/install",
                              "PREFIX=#{prefix}",
                              "PRESERVEDIR=/var/tmp/vi.recover",
                              "TERMLIB=ncurses"
  end
end

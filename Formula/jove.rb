class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "http://ftp.cs.toronto.edu/cs/ftp/pub/hugh/jove-dev/jove4.16.0.73.tgz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/jove4.16.0.73.tgz"
  sha256 "9c9e202607f5972c382098d10b63c815ac01e578f432626c982e6aa65000c630"

  bottle do
    sha256 "c232b6742b25b3ca53a7c5da2c2577d4bed34e244b2cf90a61e5a5a8ade20e7a" => :catalina
    sha256 "8ee0b5bfd6d4dab4b56551dc1bd5cf8b03909f833d90fb213be0c16babbb88af" => :mojave
    sha256 "852bb69e61f542d5741b4a442c72c8f72304468d0c1101c2843b1c272111a6d1" => :high_sierra
    sha256 "a4559511caca50cf08e01049dda2a35a9423b5c976bf0d930ba819afebc1387b" => :sierra
    sha256 "c083761f33516e9d18718b6f78f6468b9aa72c0c80bb625987c60c05cc4f1895" => :el_capitan
    sha256 "4e741042364faa5ef07f7957d9e811c204561ecad03ebbcd98f82761211ec78c" => :yosemite
    sha256 "260e22d1b9cabcc9b8cacd415d8e5cf840c6970e302a2840cb4076f3583a591d" => :mavericks
  end

  # Per MacPorts, avoid clash with libc getline
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3cada68f/jove/patch-getline.diff"
    sha256 "96e557370d6e8924cc73bda8dbe65e54f4cc902785ffcf0056d8925bb4e77bf6"
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    assert_match /There's nothing to recover./, shell_output("#{lib}/jove/recover")
  end
end

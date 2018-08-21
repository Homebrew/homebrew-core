class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  url "http://ndevilla.free.fr/iniparser/iniparser-3.1.tar.gz"
  sha256 "aedf23881b834519aea5e861b2400606d211da049cd59d3cfb4568e0d9eff5c5"
  head "https://github.com/ndevilla/iniparser.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd976b7f75d0754f92e2e7824b200d9b4393ce81ab010b133414a36e922a12d4" => :mojave
    sha256 "2cd01e81f1feacfafa6e116d366e519f9b44fef85ab683799cf32947e8606e61" => :high_sierra
    sha256 "6b6e99eb6ea00278e708518ca32a9660edd40b1d4b730accb8040e1fe24d3de2" => :sierra
    sha256 "0278cf54ff7cf350232559892ada560905b6b736ce96ed1c16550bee5bfad682" => :el_capitan
    sha256 "c31e24f968cd204eef07f40dab70174df9ac9d6d130af13b2943e8a9df00acfe" => :yosemite
    sha256 "7e211ecdcd55d267ab0921a15cf27b739b7a1af62160ac8b62dd456119c1a5d0" => :mavericks
  end

  conflicts_with "fastbit", :because => "Both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end

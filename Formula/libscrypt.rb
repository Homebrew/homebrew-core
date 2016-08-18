class Libscrypt < Formula
  desc "Library for scrypt"
  homepage "https://lolware.net/libscrypt.html"
  url "https://github.com/technion/libscrypt/archive/v1.21.tar.gz"
  sha256 "68e377e79745c10d489b759b970e52d819dbb80dd8ca61f8c975185df3f457d3"

  bottle do
    cellar :any
    sha256 "9544541a64800ca3fc88ef5e3865924cd3ca7532274558525e50ef823a23fe3d" => :el_capitan
    sha256 "d542be37b69da1feaa86854767c9854703f6a084d18d0f8305098e46bd41e000" => :yosemite
    sha256 "d3efcf02f126ad4dc94c85dd2349470a27596cbce0c0271cc421917a2005b7d1" => :mavericks
    sha256 "7bc3e3d4170a58a0e378e7ca2ac14d448984d68e049244ab7aee5bf09b91f4f6" => :mountain_lion
  end

  def install
    system "make", "install-osx", "PREFIX=#{prefix}", "LDFLAGS=", "CFLAGS_EXTRA="
    system "make", "check", "LDFLAGS=", "CFLAGS_EXTRA="
  end
end

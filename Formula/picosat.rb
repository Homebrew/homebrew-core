class Picosat < Formula
  desc "SAT solver"
  homepage "http://fmv.jku.at/picosat/"
  url "https://github.com/jordi-petit/picosat/archive/965.tar.gz"
  sha256 "54a7189fab3f7afbb79f080018aa3d9f46975a52c5f92c80cf048ee5dab38a79"

  def install
    system "./configure.sh"
    system "make"
    bin.install "picosat"
    include.install "picosat.h"
    lib.install "libpicosat.a"
  end

  test do
  end
end

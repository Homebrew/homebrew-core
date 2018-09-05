class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-2.5.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-2.5.tar.gz"
  sha256 "93a350443e431f474c4f898fe8bbe649e20957b25ce1d9d43810117128658e00"

  bottle do
    cellar :any_skip_relocation
    sha256 "537dbb19980fce982e2859e14852d31fb5f4f91fc62ef062dab427890bf334ce" => :mojave
    sha256 "fa778995e1b3d3adb26a3ebd0a584376dd85e5239cdf8417643cb2984040bb6c" => :high_sierra
    sha256 "23c036094f518eb3d98539e410ea95bbe237bda31b205f3741fb46bb7d5e32c5" => :sierra
    sha256 "fe44d3d4814322c408e59944d86d56214c6056547111957efdbf08e382d4672b" => :el_capitan
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end

class Malbolge < Formula
  desc "Deliberately difficult to program esoteric programming language"
  homepage "https://esoteric.sange.fi/orphaned/malbolge/README.txt"
  url "https://esoteric.sange.fi/orphaned/malbolge/malbolge.c"
  version "0.1.0"
  sha256 "ca3b4f321bc3273195eb29eee7ee2002031b057c2bf0c8d7a4f7b6e5b3f648c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e4b604d3ce7e8ccc5933dd949b55e77bdd59d21f084b4183b950e9dd552f368" => :sierra
    sha256 "20f743a8bcb4085f5958e65a54bc20399de6894155ecd64dfc056431d93ec477" => :el_capitan
    sha256 "e5f617b7bbfee4386442aa739ce8df21b4c54584f2a4ea9f52eec877002ecdf7" => :yosemite
    sha256 "3681aa628f0cbc4d9f2bd65d647402d05dc850041119e24515223527df261125" => :mavericks
  end

  patch :DATA

  def install
    system ENV.cxx, "malbolge.c", "-o", "malbolge"
    bin.install "malbolge"
  end
end

__END__
--- /malbolge.c
+++ /malbolge.c 
25d24
< #include <malloc.h>

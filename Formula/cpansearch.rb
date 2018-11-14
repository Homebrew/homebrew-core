class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"
  head "https://github.com/c9s/cpansearch.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "69d0e81fd62ba200820ccb848d4b10d970cf01146724653652434d36743a5356" => :mojave
    sha256 "5d9c3bb958793897bc8933394d1a6a62df3c60a0f96bd8ac33f6486a3f62e8cd" => :high_sierra
    sha256 "29e1acab7f1755337460172f853968b116d831b43948f6727f5565f3b9ce248e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000

  def install
    system "make"
    bin.install "cpans"
  end

  test do
    output = shell_output("#{bin}/cpans --fetch https://cpan.metacpan.org/")
    assert_match "packages recorded", output
  end
end

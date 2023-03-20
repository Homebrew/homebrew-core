class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7v.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7v.orig.tar.gz"
  sha256 "f3dec3f6102770196976459c4b44ac27355f6120da76e5231ec1323e379d1511"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66b12ef2111da682532b6a745465a0518d9f62f225c8f721e54de879e202c9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb92f280ed1b571d91217a48eb4b5c7369620c45d2b6a55ad6678890eb7d7b56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c48d435813db09cb41c3a478d2d0b5dcfea5798ac5f326870b4be8551f8fd4e4"
    sha256 cellar: :any_skip_relocation, ventura:        "f43845911736c5506cc0ffe3160cb25f4806a0d78c71537d5fc26a405b3bed24"
    sha256 cellar: :any_skip_relocation, monterey:       "5677c429de0a06a71ff73f2a5e2d4812f7f06a648df63752325906539da65ca0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8144d5fbd994924bb14a473a26211e7c3e7d5cc45606ff82c2f6023b48fe64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef0e5ac3dd5df85888a5c06e8dbec67142174fdc95f789caa880a64655c5255"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end

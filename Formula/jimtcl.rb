class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "http://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/0.82.tar.gz"
  sha256 "e8af929b815e4d30e54ff116b2b933e56c00a02b9110529d1a58660b2469aea7"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_ventura:  "f80310436f9d2bc8d96178eb91a2ed561a3d935ca55046784c5e6a46a61895a1"
    sha256 arm64_monterey: "ee69a018ea4c1fcad3d71040c0cf0d76fb886b493ac7b70345208ce0504ae0bc"
    sha256 arm64_big_sur:  "43167817009a55f2d14e7378356d6c00d46570e1ccd7fe9bf012c23495c77398"
    sha256 ventura:        "b55f9946c4311018d373f84a7a02c5ed128793e0f1df7519a5848d4baf286c6f"
    sha256 monterey:       "bcb43b78367cc5b8f0814055268befc4ca46ee23afc007f36e14b534477a9668"
    sha256 big_sur:        "b6f6bfd82e8514a83dd2a5ff0b3d8a172c85c102df7b87d1ecc4e85753fa72ac"
    sha256 x86_64_linux:   "4b1193b996cd8fb9c7c6e41c9bb047c7a7b04238fc56fc8f9f6c67a58b291c1c"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--full",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--maintainer",
                          "--math",
                          "--ssl",
                          "--utf8"
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end

class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v6.0.tar.gz"
  sha256 "1f540a7389d30fcf9f8cd9897617cc68b19350fbcde97c4d1cdc5634de1992c6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Caltech-IPAC/Montage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f669dea76769203b2b971c321d43a92c1741ef7332accd78d498388c08a70d73"
    sha256 cellar: :any, arm64_monterey: "32ca9b9c2b38f96f315089ea6a0ac53a1e46a56d5a19e8448976728a7b61e770"
    sha256 cellar: :any, arm64_big_sur:  "f11424edd9f5e990992a1f3ca2109bab5b379cd1315a20f6aca9325737451868"
    sha256 cellar: :any, ventura:        "0837c7341caeb05381ce1af16c934ab873c934401ae9943a0e26701ee5d90143"
    sha256 cellar: :any, monterey:       "7bde65d353daef1efbc2905d9020dc5be21209432acd60082b7e846974b13e59"
    sha256 cellar: :any, big_sur:        "4b0e265c15f132b49b7f92f181c9d68f92c5b2a7150b36ebada3af966401d733"
    sha256 cellar: :any, catalina:       "fa8e44313ba11b9784a9ae19a993613c5eaca2089ef7c50ac72ef486fb06d7a5"
  end

  depends_on "cfitsio"
  depends_on "freetype"
  depends_on "jpeg-turbo"

  uses_from_macos "bzip2"

  conflicts_with "wdiff", because: "both install an `mdiff` executable"

  def install
    # Avoid building bundled libraries
    libs = %w[bzip2 cfitsio freetype jpeg]
    buildpath.glob("lib/src/{#{libs.join(",")}}*").map(&:rmtree)
    inreplace "lib/src/Makefile", /^[ \t]*\(cd (?:#{libs.join("|")}).*\)$/, ""
    inreplace "MontageLib/Makefile", %r{^.*/lib/src/(?:#{libs.join("|")}).*$\n}, ""
    inreplace "MontageLib/Viewer/Makefile.#{OS.kernel_name.upcase}",
              "-I../../lib/freetype/include/freetype2",
              "-I#{Formula["freetype"].opt_include}/freetype2"

    ENV.deparallelize # Build requires targets to be built in specific order
    system "make"
    bin.install Dir["bin/m*"]
  end

  def caveats
    <<~EOS
      Montage is under the Caltech/JPL non-exclusive, non-commercial software
      licence agreement available at:
        http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end

  test do
    system bin/"mHdr", "m31", "1", "template.hdr"
  end
end

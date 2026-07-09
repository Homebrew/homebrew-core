class Mash < Formula
  desc "Fast genome distance estimation using MinHash"
  homepage "https://github.com/marbl/Mash"
  url "https://github.com/marbl/Mash/archive/refs/tags/v2.3.tar.gz"
  sha256 "f96cf7305e010012c3debed966ac83ceecac0351dbbfeaa6cd7ad7f068d87fe1"
  license "BSD-3-Clause"
  head "https://github.com/marbl/Mash.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "gsl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Newer compilers need explicit <cstdint>/<limits> includes, and the
    # bundled build pins -std=c++14 while the current Cap'n Proto requires C++17.
    ENV.append "CXXFLAGS", "-include cstdint -include limits"
    inreplace ["Makefile.in", "configure.ac"], "-std=c++14", "-std=c++17"
    # Drop the glibc-symbol-pinning memcpy wrapper: it forces memcpy@GLIBC_2.2.5,
    # which the Homebrew toolchain does not provide (Homebrew targets its own glibc).
    inreplace "Makefile.in", " -include src/mash/memcpyLink.h -Wl,--wrap=memcpy", ""
    inreplace "Makefile.in", "-include src/mash/memcpyLink.h", ""
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--with-capnp=#{formula_opt_prefix("capnp")}",
                          "--with-gsl=#{formula_opt_prefix("gsl")}"
    system "make"
    bin.install "mash"
    doc.install Dir["doc/sphinx/*"]
    pkgshare.install "data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mash --version 2>&1")
    system bin/"mash", "sketch", "-o", "test", pkgshare/"data/genome1.fna"
    assert_match "Sketches:", shell_output("#{bin}/mash info test.msh")
  end
end

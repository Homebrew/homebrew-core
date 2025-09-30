class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "https://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/refs/tags/0.83.tar.gz"
  sha256 "6f2df00009f5ac4ad654c1ae1d2f8ed18191de38d1f5a88a54ea99cc16936686"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:    "25a7a46cc3cc542460e7309eca1c67570b58a813236e11152c929e41cbd9f737"
    sha256 arm64_sequoia:  "855f8a678aa16fa313e1e74b4ca765afb34f3fce0a5eb130bc8f4d14da5aed6f"
    sha256 arm64_sonoma:   "73774db53edbfc7791a6f2c328f63ef7a7555b103c1ada101e110590aeeea3d4"
    sha256 arm64_ventura:  "a5a65010c3d6c3d72a8d6bdf0dc6a230232d1d5477e065f3bc4a631f6b4e3c1a"
    sha256 arm64_monterey: "cde5346b6488d9224d512b678eb500ee9f63c95b16eea5001775f998ad9c789a"
    sha256 sonoma:         "802498062a817cb2055c3d30c5a5945f369ca08b08bc8945d36aec2942b711b9"
    sha256 ventura:        "37aeca2006f2608fd5d788839b4c51505df48b4bbe94bbb44f3122404993adfc"
    sha256 monterey:       "4b9b6ed2f15335aebba924e148b4907c9b199634b718ad9460270ebc8f434d8d"
    sha256 arm64_linux:    "d48ad33e08260ec0ae9acbe19e9f473fc04d2381196b5b603ee7743716892af4"
    sha256 x86_64_linux:   "66fc34a8124311fd4888cfbadf04c6bb1a1f4804ed20f19fb08a39417322ca62"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  # patch to include `stdio.h``
  patch do
    url "https://github.com/msteveb/jimtcl/commit/35e0e1f9b1f018666e5170a35366c5fc3b97309c.patch?full_index=1"
    sha256 "50f66a70d130c578f57d9569b62cf7071f7a3a285ca15efefd3485fa385469ba"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--ssl",
                          *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end

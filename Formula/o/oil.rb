class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.23.0.tar.gz"
  sha256 "9fcc3eabaacf1324c49aa583b9a6fcbf80dd9ea47088632722abc95de3629b6b"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "d9690ca442936dd7f511ea47b9f38dd8f1e912d750f2f973436484d9bbab5498"
    sha256 arm64_sonoma:   "3bd17a6e3a21658e3ea556d2e83658a31ebacb4c44d2cf2a545d7fcc13d4be7b"
    sha256 arm64_ventura:  "c6d90b4d1ed90b69341594a1c2cc5dad0b7589103117a8a56b1c35f67a3d1858"
    sha256 arm64_monterey: "3a6ee4291d757da8bd9c7057b6b90e596717e8594968cbe822e656cedf7eab32"
    sha256 sonoma:         "0f38753bfbf381e4a8095ffb66c1af9c0685c0f0c85fe3619e8385862a3fc030"
    sha256 ventura:        "aa527672e7c1448cbcd46787f0e349431ffb0116a438593ddb451eae40fb441e"
    sha256 monterey:       "cf0c11fb7b3a7a5826e9b25748060c298dee565bd16257b568a7c4bb0b9efd0c"
  end

  depends_on "readline"

  conflicts_with "oils-for-unix", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end

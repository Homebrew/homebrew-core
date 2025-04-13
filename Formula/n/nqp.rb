class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.03/nqp-2025.03.tar.gz"
  sha256 "967927457fd0db6540570a58482efcd5f8f386ca28a702d353b0058d0894527f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "2261e2610eae0afad5aee8d1d31e10c6ae833fb4d97565513ea8dfd3139bcf73"
    sha256 arm64_sonoma:  "b3c5980a0f5ea8d0dfbec7f41211eef586b47c70ba29e494d036c95f51c0d9af"
    sha256 arm64_ventura: "e9911d18807d405427dee45c3bf54c59c38ffe571164106cd556a5a2bd293804"
    sha256 sonoma:        "a71a5f432242348b14179ddac9a0fc9b96bf6ef43d28111424fad298ac66adef"
    sha256 ventura:       "134f4c13df45f7b620a6db818f59ae0cab4a9ddbacaacb0e1955010339ba8bcb"
    sha256 arm64_linux:   "5cfb882c2fefd5c8a885d614caab23b00abb94b71cd1ae00ec93c9b83dcb4506"
    sha256 x86_64_linux:  "fd2b5760d2daae8f15cdba1f0e01dba2493c8f5252048b3d7bd4b8c197bf2bba"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end

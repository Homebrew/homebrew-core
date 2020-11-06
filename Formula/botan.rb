class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.17.0.tar.xz"
  sha256 "b97044b312aa718349af7851331b064bc7bd5352400d5f80793bace427d01343"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "d119a8a032b7bc778054109bcac38c3e7dd63a352f7f1d462d9e9cd4e987e030" => :catalina
    sha256 "6a617380241089e14f2c13eb887f2dd4eef7eec1d4395781338495b558a5c48e" => :mojave
    sha256 "57fb28fc92e902e75bdf89892c2404b147210df0f3980b2d9dddc579e2a7c1a6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cc=#{ENV.compiler}
      --os=darwin
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --with-python-versions=3.9
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end

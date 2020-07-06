class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.15.0.tar.xz"
  sha256 "d88af1307f1fefac79aa4f2f524699478d69ce15a857cf2d0a90ac6bf2a50009"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "bd68e97faa7176a2f13f37ab82eac7e16741df8c605921df0e9fff62a178ecfd" => :catalina
    sha256 "028b813523b0466859ac83cc4a785f3fa1bf7941f9fdb4c0c7dc14bcdfd2bc46" => :mojave
    sha256 "729e265be59f87467919084a752fa793c94a8f06898bfb9b0439a0aec1f8ee54" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8"
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
      --with-python-versions=3.8
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

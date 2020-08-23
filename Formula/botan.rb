class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.15.0.tar.xz"
  sha256 "d88af1307f1fefac79aa4f2f524699478d69ce15a857cf2d0a90ac6bf2a50009"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "eadcaecf6012c8e8a79f867ae1f71dbf25064b1134034c132b359677fbcf85ee" => :catalina
    sha256 "a0974f73218cea782cab67f747ed4d355790d99ea8abba58ccdc651a2f755ca1" => :mojave
    sha256 "3ac585173960885e4dabb36db032e0d651e6a2b567575b27e24b01ec352ff055" => :high_sierra
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

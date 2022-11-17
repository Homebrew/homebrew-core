class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.3.tar.xz"
  sha256 "dae047f399c5a47f087db5d3d9d9e8f11ae4985d14c928d71da1aff801802d55"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?Botan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "8311eedfb236b3aee68cc1d913d57c43c017de80a4ee3d094003041dfb080a1d"
    sha256 arm64_monterey: "8f5c3bc2bbe2b86e160c827467f6a76cdc32e697133f3a5cedada3dac619f5e7"
    sha256 arm64_big_sur:  "17f28fa296307abf8c2464c52f965f885b366b94d84058ffa0f8c99541237124"
    sha256 monterey:       "ee0726d2408986517344a3c8d0796cf91d775c6fb54653ee48ff4598d472ef70"
    sha256 big_sur:        "78802203de558954599b60110a980c48378880c76bc7283c3152281ca42b044a"
    sha256 catalina:       "6a44a1522a3532eb8e8f30e914e09b172b595556afbb2de91580c858151627b0"
    sha256 x86_64_linux:   "77d8ce77a7c8505cc7779f5281bbbe999db6dfcc3f094fe464a70d4895b39b40"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system "python3.11", "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end

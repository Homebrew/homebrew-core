class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.17.1.tar.xz"
  sha256 "741358b3f1638ed7d9b2f59b4e344aa46f4966b15958b5434c0ac1580df0c0c1"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "14546ba08d9ec11890a98119b558da02a138348a9fed0776d8cc3ea5f9c0edc6" => :catalina
    sha256 "115eb65b2d60568912c666cd277322c70c5421e0162dc2b331b7062a4d8023b1" => :mojave
    sha256 "865bd45f6c8e089f74826319eb6fd974b56e3dbcda38dc54fe7518e7e18239be" => :high_sierra
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
